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
    
    movie = mock(:movie).as_null_object
    Movie.should_receive(:where).and_return(Movie)
    Movie.should_receive(:order).and_return(Movie)
    Movie.should_receive(:find_each).twice.and_yield(movie)
    movie.should_receive(:update_swarm_score)
    
    Source::TorrentSource.update
  end 

  it 'should set the movie rank' do
    pb_source = mock(:pirate_bay_source).as_null_object
    Source::PirateBaySource.stub!(:new).and_return(pb_source)
    
    movie = mock(:movie).as_null_object
    movie2 = mock(:movie).as_null_object
    Movie.should_receive(:where).and_return(Movie)
    Movie.should_receive(:order).and_return(Movie)
    Movie.should_receive(:find_each).twice.and_yield(movie).and_yield(movie2)
    movie.should_receive(:update_attribute).with(:current_rank, 1)
    movie2.should_receive(:update_attribute).with(:current_rank, 2)
    
    Source::TorrentSource.update
  end

  it 'should set rank to null if movie has a 0 swarm score' do
    movie = Movie.create!(:name => 'rank reset', :year => 2000, :swarm_score => 0, :current_rank => 2)

    pb_source = mock(:pirate_bay_source).as_null_object
    Source::PirateBaySource.stub!(:new).and_return(pb_source)
    Movie.stub!(:find_each)

    Source::TorrentSource.update
    movie.reload.current_rank.should be_nil
  end  
  
end  
