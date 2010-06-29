require 'spec_helper'

describe Movie do
  
  before(:each) do
    Torrent.stub!(:associate_with_movie)
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
end
