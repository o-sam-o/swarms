require 'spec_helper'
describe Source::PirateBaySource do

  it 'should source torrent' do
    Net::HTTP.should_receive(:post_form).exactly(5).times.and_return(mock(:response, :body => IO.read(File.join(File.dirname(__FILE__), 'yql_sample.xml'))))
  
    stats = mock(:stats)
    torrent = mock(:torrent, :stats => stats)
    Torrent.should_receive(:find_or_create_by_name).exactly(1).times.with('The_A_Team_2010_TS_XViD_-_IMAGiNE.5622259.TPB.torrent').and_return(torrent)
    stats.should_receive(:create!).exactly(1).times.with(:seeds => '8557', :leaches => '5142')    
  
    Source::PirateBaySource.new.refresh.should =~ /Found 1 torrents/
  end

end
