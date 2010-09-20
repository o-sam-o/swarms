require 'spec_helper'

describe TorrentStat do
  it 'should provide swarm size' do
    torrent = Torrent.new(:name => 'test.torrent')
    torrent.stub!(:associate_with_movie)
    torrent.save!
    stat = TorrentStat.create!(:seeds => 1, :leaches => 5, :torrent => torrent)
    stat.swarm_size.should == 6
  end  
end
