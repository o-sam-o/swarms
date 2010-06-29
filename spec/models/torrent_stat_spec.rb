require 'spec_helper'

describe TorrentStat do
  it 'should provide swarm size' do
    stat = TorrentStat.new(:seeds => 1, :leaches => 5)
    stat.swarm_size.should == 6
  end  
end
