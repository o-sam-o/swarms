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
  
  it 'should return the latest swarm count' do
      movie = Movie.create!(:name => 'Movie', :year => 2000)
      
      torrent1 = Torrent.create!(:name => 'test.torrent', :movie => movie)
      torrent1.torrent_stats.create!(:seeds => 10, :leaches => 2)
      latest1 = torrent1.torrent_stats.build(:seeds => 11, :leaches => 30)
      latest1.created_at = Date.civil(2020, 1, 1)
      latest1.save!

      torrent2 = Torrent.create!(:name => 'test2.torrent', :movie => movie)
      torrent2.torrent_stats.create!(:seeds => 100, :leaches => 32)

      movie.torrents.latest_swarm_count.should == (100 + 32 + 11 + 30)
  end  
  
  it 'should display name with year' do
    Movie.new(:name => 'title', :year => 2000).display_name.should == "title (2000)"
  end  
  
  
  it 'should display name with year' do
    Movie.new(:name => 'title', :year => '').display_name.should == "title"
    Movie.new(:name => 'title').display_name.should == "title"    
  end  
  
  context 'find_or_create_by_imdb_id' do
    before(:each) do
      @movie = Movie.create!(:name => 'test', :year => 2000, :imdb_id => '123')
    end
    
    it 'should check to see if a movie already exists first' do
      Movie.should_receive(:find_by_imdb_id).with('123').and_return(@movie)
      
      Movie.find_or_create_by_imdb_id('123').should == @movie
    end  
    
    it 'should scrap imdb if a movie doesnt exist' do
      Movie.should_receive(:find_by_imdb_id).with('123').and_return(nil)
      YayImdbs.should_receive(:scrap_movie_info).with('123').and_return({'title' => 'test', 'year' => 2000})      
      Movie.should_receive(:create!).with(:name => 'test', :year => 2000, :imdb_id => '123')
      
      Movie.find_or_create_by_imdb_id('123')
    end    
    
    it 'should download poster images if urls provided' do
      Movie.should_receive(:find_by_imdb_id).with('123').and_return(nil)
      YayImdbs.should_receive(:scrap_movie_info).with('123').and_return({'title' => 'test', 'year' => 2000, 
                                                        :small_image => 'small_url', :large_image => 'large_url'})      
      Movie.should_receive(:create!).with(:name => 'test', :year => 2000, :imdb_id => '123').and_return(@movie)
      
      MovieImage.should_receive(:download_image).with('small_url', @movie, :small)
      MovieImage.should_receive(:download_image).with('large_url', @movie, :poster)
      
      Movie.find_or_create_by_imdb_id('123')
    end    
    
    it 'should not download poster images if no urls provided' do
      Movie.should_receive(:find_by_imdb_id).with('123').and_return(nil)
      YayImdbs.should_receive(:scrap_movie_info).with('123').and_return({'title' => 'test', 'year' => 2000})      
      Movie.should_receive(:create!).with(:name => 'test', :year => 2000, :imdb_id => '123').and_return(@movie)
      
      MovieImage.should_not_receive(:download_image)
      
      Movie.find_or_create_by_imdb_id('123')
    end    
  end  
end
