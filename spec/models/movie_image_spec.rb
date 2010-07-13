require 'spec_helper'

describe MovieImage do
  
  it 'should determine the file image folder' do
    MovieImage.complete_file_name(stub(:movie, :id => 1, :name => 'movie1'), 'http://test.com/image.jpg', nil).should == "#{RAILS_ROOT}/public/posters/000/001/movie1.jpg"
    MovieImage.complete_file_name(stub(:movie, :id => 10_000, :name => 'Movie2'), 'http://test.com/im.age.gif', :small).should == "#{RAILS_ROOT}/public/posters/010/000/movie2_small.gif"
  end  
  
end
