require 'spec_helper'

describe Source::TorrentSource do
  
  it 'should call the pirate bay soruce' do
    pb_source = mock(:pirate_bay_source)
    Source::PirateBaySource.should_receive(:new).and_return(pb_source)
    pb_source.should_receive(:refresh)
    
    Source::TorrentSource.update
  end  
  
  it 'should update movie swarm_scores' do
    pb_source = mock(:pirate_bay_source).as_null_object
    Source::PirateBaySource.stub!(:new).and_return(pb_source)
    
    movie = mock(:movie)
    Movie.should_receive(:find_each).and_yield(movie)
    movie.should_receive(:update_swarm_score)
    
    Source::TorrentSource.update
  end  
  
end  