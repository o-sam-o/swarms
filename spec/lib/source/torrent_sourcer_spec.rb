require 'spec_helper'

describe Source::TorrentSourcer do
  include Source::TorrentSourcer
  
  it 'should run yql queries' do
    Net::HTTP.should_receive(:post_form).and_return(mock(:response, :body => 'xml'))
    yql('test query').should == 'xml'
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
      extract_xpaths(SAMPLE_XML, '//node') do |result|
        index += 1
        result.should == "text#{index}"
      end
      
      index.should == 3
    end  
  
    it 'should source two xpath' do
      index = 0
      extract_xpaths(SAMPLE_XML, '//node', '//node/@att') do |result1, result2|
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
    
    record_stats('torrent name', 10, 100)
  end

end