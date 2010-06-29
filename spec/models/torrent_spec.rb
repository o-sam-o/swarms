require 'spec_helper'

describe Torrent do

  before(:each) do
    Torrent.stub!(:associate_with_movie)
  end  

  it 'should require name' do
    torrent = Torrent.new
    torrent.should_not be_valid
    torrent.name = 'Movie.name.torrent'
    torrent.should be_valid
  end

  it 'should return the latest stats' do
    torrent = Torrent.create!(:name => 'test.torrent')
    torrent.torrent_stats.create!(:seeds => 10, :leaches => 2)
    latest = torrent.torrent_stats.build(:seeds => 11, :leaches => 30)
    latest.created_at = Date.civil(2020, 1, 1)
    latest.save!
    
    torrent.torrent_stats.latest.should == latest
  end  

end
