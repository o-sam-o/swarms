require 'spec_helper'

describe TorrentSource do

  it 'should run yql queries' do
    Net::HTTP.should_receive(:post_form).and_return(mock(:response, :body => 'xml'))
    TorrentSource.new.yql('test query').should == 'xml'
  end  

  context 'xpaths' do

    SAMPLE_XML = %{
      <root>
        <node att="att1">text1</node>
        <node att="att2">text2</node>
        <node att="att3">text3</node>
      </root>
    }

    it 'should source one xpath' do
      index = 0
      TorrentSource.new.extract_xpaths(SAMPLE_XML, '//node') do |result|
        index += 1
        result.should == "text#{index}"
      end
      
      index.should == 3
    end  
  
    it 'should source two xpath' do
      index = 0
      source = TorrentSource.new
      source.extract_xpaths(SAMPLE_XML, '//node', '//node/@att') do |result1, result2|
        index += 1
        result1.should == "text#{index}"
        result2.should == "att#{index}"
      end
      
      index.should == 3
    end
  
  end
  
  it 'should record torrent stats' do
    stats = mock(:stats)
    torrent = mock(:torrent, :stats => stats)
    Torrent.should_receive(:find_or_create_by_name).with('torrent name').and_return(torrent)
    stats.should_receive(:create!).with(:seeds => 10, :leaches => 100)
    
    source = TorrentSource.new
    source.record_stats('torrent name', 10, 100)
  end  
  
  it 'should source torrent' do
    Net::HTTP.should_receive(:post_form).and_return(mock(:response, :body => IO.read(File.join(File.dirname(__FILE__), 'yql_sample.xml'))))
    
    stats = mock(:stats)
    torrent = mock(:torrent, :stats => stats)
    Torrent.should_receive(:find_or_create_by_name).with('The_A_Team_2010_TS_XViD_-_IMAGiNE.5622259.TPB.torrent').and_return(torrent)
    stats.should_receive(:create!).with(:seeds => '8557', :leaches => '5142')    
    
    TorrentSource.update.should == "Found 1 torrents"
  end  

end  