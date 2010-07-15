require 'spec_helper'

describe MovieImage do
  
  it 'should determine the file image folder' do
    MovieImage.complete_file_name(stub(:movie, :id => 1, :name => 'movie1'), 'http://test.com/image.jpg', nil).should == "#{Rails.root}/public/images/posters/000/001/movie1.jpg"
    MovieImage.complete_file_name(stub(:movie, :id => 10_000, :name => 'movie2'), 'http://test.com/im.age.gif', :small).should == "#{Rails.root}/public/images/posters/010/000/movie2_small.gif"
  end  
  
  it 'it should strip case and non characters' do
    MovieImage.complete_file_name(stub(:movie, :id => 1, :name => 'Movie 1'), 'http://test.com/image.jpg', nil).should == "#{Rails.root}/public/images/posters/000/001/movie_1.jpg"
    MovieImage.complete_file_name(stub(:movie, :id => 10_000, :name => 'Movie2|\\*/'), 'http://test.com/im.age.GIF', :small).should == "#{Rails.root}/public/images/posters/010/000/movie2_small.gif"
  end  
  
  it 'should download image and create model' do
    @images = mock(:movie_images)
    @movie = mock(:movie, :movie_images => @images)
    MovieImage.should_receive(:complete_file_name).and_return(MovieImage::IMAGE_BASE_DIR + 'test.jpg')
    MovieImage.should_receive(:get_image).with(MovieImage::IMAGE_BASE_DIR + 'test.jpg', 'image_url')
    ImageSize.stub!(:new).and_return(mock(:image_size, :get_size => [10, 20]))
    File.stub!(:new)
    
    @images.should_receive(:create!).with(:file_name => 'test.jpg', :width => 10, :height => 20, :format => 'poster')
    
    MovieImage.download_image('image_url', @movie, :poster)
  end  
  
end
