require 'spec_helper'

describe Genre do
  it 'should vaidate the presents of name' do
    genre = Genre.new
   
    genre.should_not be_valid

    genre.name = 'test'
    genre.should be_valid
  end 
end
