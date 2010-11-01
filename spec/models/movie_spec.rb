require 'spec_helper'

describe Movie do
  
  before(:each) do
    YayImdbs.stub!(:search_for_imdb_id)
  end
  
  it 'should require name' do
    movie = Movie.new(:year => 2000)
    movie.should_not be_valid
    movie.name = 'Movie name'
    movie.should be_valid
  end  
  
  it 'should require year' do
    movie = Movie.new(:name => 'Movie')
    movie.should_not be_valid
    movie.year = 2000
    movie.should be_valid
  end
  
  it 'should have genres' do
    g1 = Genre.create!(:name=>'action')
    g2 = Genre.create!(:name=>'Drama')

    m = Movie.create!(:name => 'test', :year => 2000, :genres => [g1, g2])  

    m.genres.should == [g1, g2]
  end

  context 'torrent counts' do
  
    before(:each) do
      @movie = Movie.create!(:name => 'Movie', :year => 2000)
    
      torrent1 = Torrent.create!(:name => 'test.torrent', :movie => @movie)
      older1 = torrent1.torrent_stats.create!(:seeds => 10, :leaches => 2)
      older1.update_attribute(:created_at, 1.day.ago)

      latest1 = torrent1.torrent_stats.create!(:seeds => 11, :leaches => 30)

      torrent2 = Torrent.create!(:name => 'test2.torrent', :movie => @movie)
      torrent2.torrent_stats.create!(:seeds => 100, :leaches => 32)  
    end  
  
    it 'should return the latest swarm count' do
      @movie.torrents.latest_swarm_count.should == (100 + 32 + 11 + 30)
    end  
  
    it 'should return the latest leaches count' do
      @movie.torrents.latest_leaches_count.should == (32 + 30)
    end

    it 'should return the latest seeds count' do
      @movie.torrents.latest_seeds_count.should == (11 + 100)
    end
    
    it 'should set a movies torrent score' do
      @movie.update_attribute(:swarm_score, 1)
      @movie.update_swarm_score(10.seconds.ago)
      @movie.swarm_score.should == (100 + 32 + 11 + 30)
    end  
  
  end
  
  it 'should display name with year' do
    Movie.new(:name => 'title', :year => 2000).display_name.should == "title (2000)"
  end  
  
  
  it 'should display name with year' do
    Movie.new(:name => 'title', :year => '').display_name.should == "title"
    Movie.new(:name => 'title').display_name.should == "title"    
  end  
  
  context :find_or_create_by_imdb_id do
    before(:each) do
      @movie = Movie.create!(:name => 'test', :year => 2000, :imdb_id => '123')
    end
    
    it 'should check to see if a movie already exists first' do
      Movie.should_receive(:find_by_imdb_id).with('123').and_return(@movie)
      
      Movie.find_or_create_by_imdb_id('123').should == @movie
    end  
    
    it 'should scrap imdb if a movie doesnt exist' do
      Movie.should_receive(:find_by_imdb_id).with('123').and_return(nil)
      info = {'title' => 'test', 'year' => 2000}
      YayImdbs.should_receive(:scrap_movie_info).with('123').and_return(info)      
      Movie.should_receive(:create_from_imdb_info).with(info, '123')
      
      Movie.find_or_create_by_imdb_id('123')
    end    
  end

  context :create_from_imdb_info do
    it 'should populate movie fields from imdb data' do
      info = {:title => 'title', :year => 2000, :director => 'director', :language => 'English', 
              :plot => 'plot here', :mpaa => 'pg', :not_used_data => 'dummy', 
              :runtime => 100, :release_date => Date.civil(2010, 1, 1),
              :genre => ['Action']}.with_indifferent_access
      
      genre = mock(:genre).as_null_object
      Genre.should_receive(:find_or_create_by_name).with('Action').and_return(genre)

      Movie.should_receive(:create!).with({:name => 'title', :year => 2000, :director => 'director', 
                                          :language => 'English', :plot => 'plot here', :classification => 'pg',
                                          :runtime => 100, :release_date => Date.civil(2010, 1, 1),
                                          :genres => [genre], :imdb_id => '123'})
      

      Movie.create_from_imdb_info(info, '123')
    end 

    it 'should download poster images if urls provided' do
      Movie.should_receive(:create!)
      
      MovieImage.should_receive(:download_image).with('small_url', @movie, :small)
      MovieImage.should_receive(:download_image).with('large_url', @movie, :poster)
      
      Movie.create_from_imdb_info({'title' => 'test', 'year' => 2000, :small_image => 'small_url', 
                                  :large_image => 'large_url'}, '123')
    end    
    
    it 'should not download poster images if no urls provided' do
      Movie.should_receive(:create!)
      
      MovieImage.should_not_receive(:download_image)
      
      Movie.create_from_imdb_info({'title' => 'test', 'year' => 2000}, '123')
    end    
  end 

 it 'should refresh from imdb' do
    info = mock(:info).as_null_object
    YayImdbs.should_receive(:scrap_movie_info).with('123').and_return(info)    
    MovieImage.stub(:download_image)
    params = mock(:params)
    Movie.should_receive(:convert_imdb_info_to_params).with(info, '123').and_return(params)
    
    movie = Movie.new(:imdb_id => '123')
    movie.should_receive(:update_attributes!).with(params)
    movie.refresh_from_imdb!
 end

 context 'previous swarm score' do
  it 'should set the previous score is swarm score changes' do
   m = Movie.create!(:name => 'test', :year => 2000, :swarm_score => 100)
   m.previous_swarm_score.should be_nil
   m.update_attributes!(:swarm_score => 200)
    
   m.swarm_score.should == 200
   m.previous_swarm_score.should == 100
  end

  it 'should not update previous score if update doesnt change swarm score' do
   m = Movie.create!(:name => 'test', :year => 2000, :swarm_score => 200, :previous_swarm_score => 100)
   m.previous_swarm_score.should == 100
   m.update_attributes!(:name => 'new')
    
   m.swarm_score.should == 200
   m.previous_swarm_score.should == 100
  end  
 end 

  it 'should detect if swarm score is up' do
    m = Movie.new(:swarm_score => 10, :previous_swarm_score => 5)
    m.should be_swarm_score_up

    m.swarm_score = 5
    m.should_not be_swarm_score_up
    m.swarm_score = nil
    m.should_not be_swarm_score_up
  end

  it 'should detect if swarm score is down' do
    m = Movie.new(:swarm_score => 5, :previous_swarm_score => 10)
    m.should be_swarm_score_down

    m.swarm_score = 10
    m.should_not be_swarm_score_down

    m.swarm_score = nil
    m.should_not be_swarm_score_down
  end

  context 'movie code' do
    it 'should set the movie code on save' do
      m = Movie.create!(:name => 'Movie Name', :year => 2000)
      m.movie_code.should == 'movie-name-2000'
    end

    it 'should handle duplicate codes' do
      m = Movie.create!(:name => 'Movie ', :year => 2000)
      m.movie_code.should == 'movie--2000'

      m2 = Movie.create!(:name => 'Movie-', :year => 2000)
      m2.movie_code.should == 'movie--2000-2'
    end  

    it 'should strip no ascii chars from a movie name' do
      m = Movie.create!(:name => 'Movie !%/Name\(*)', :year => 2000)
      m.movie_code.should == 'movie-name-2000'
    end  

    it 'should require the movie code to be unique' do
      m = Movie.create!(:name => 'Movie-', :year => 2000)
      m.movie_code.should == 'movie--2000'

      m2 = Movie.create!(:name => 'Movie ', :year => 2000)
      m2.movie_code.should == 'movie--2000-2'

      m2.movie_code = 'movie--2000'
      m2.should_not be_valid
    end  
  end
end
