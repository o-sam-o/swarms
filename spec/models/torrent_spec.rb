require 'spec_helper'

describe Torrent do

  before(:each) do
    YayImdbs.stub!(:search_for_imdb_id)
  end  

  it 'should require name' do
    torrent = Torrent.new
    torrent.stub!(:associate_with_movie)
    torrent.should_not be_valid
    torrent.name = 'Movie.name.torrent'
    torrent.should be_valid
  end

  it 'should return the latest stats' do
    torrent = Torrent.new(:name => 'test.torrent')
    torrent.stub!(:associate_with_movie)
    torrent.save!
    torrent.torrent_stats.create!(:seeds => 10, :leaches => 2)
    latest = torrent.torrent_stats.build(:seeds => 11, :leaches => 30)
    latest.created_at = Date.civil(2020, 1, 1)
    latest.save!
    
    torrent.torrent_stats.latest.should == latest
  end  
  
  context :associate_with_movie do
  
    before(:each) do
      @movie = Movie.create!(:name => 'test', :year => 2000)
    end  
  
    it 'should associate with a movie' do
      torrent = Torrent.new(:name => 'test.torrent')
      torrent.should_receive(:associate_with_movie)
      torrent.save!
    end  
  
    it 'should try to find the movie if its already presnet' do
      torrent = Torrent.new(:name => 'test.torrent', :movie => @movie)
      torrent.should_receive(:associate_with_movie)
      Util::FileNameCleaner.should_not_receive(:get_name_info)
      torrent.save!
    end
  
    it 'should try to find similar movies by name' do
      Util::FileNameCleaner.should_receive(:get_name_info).and_return(mock(:file_info, :name => 'test', :year => '').as_null_object)
      Movie.should_receive(:find_by_name).with('test').and_return(@movie)
      
      torrent = Torrent.create!(:name => 'test.torrent')
      
      torrent.movie.should == @movie
    end  
  
    it 'should try to find similar movies by name and year' do
      Util::FileNameCleaner.should_receive(:get_name_info).and_return(mock(:file_info, :name => 'test', :year => 2000))
      Movie.should_receive(:find_by_name_and_year).with('test', 2000).and_return(@movie)
      
      torrent = Torrent.create!(:name => 'test[2000].torrent')
      
      torrent.movie.should == @movie
    end
  
    it 'should search imdb if it cant find similar movies' do
      Util::FileNameCleaner.should_receive(:get_name_info).and_return(mock(:file_info, :name => 'test', :year => 2000))
      Movie.should_receive(:find_by_name_and_year).with('test', 2000).and_return(nil)
      YayImdbs.should_receive(:search_for_imdb_id).and_return('123')
      Movie.should_receive(:find_or_create_by_imdb_id).with('123').and_return(@movie)
      
      torrent = Torrent.create!(:name => 'test[2000].torrent')
      
      torrent.movie.should == @movie
    end
  
  end

end
