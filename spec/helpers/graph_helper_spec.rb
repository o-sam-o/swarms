require 'spec_helper'

describe GraphHelper do

  context :data_points do
    
    it 'should return the leaches data points' do
      movie = Movie.create!(:name => 'test', :year => 2000)
      stat1 = MovieStat.create!(:movie => movie, :seeds => 1, :leaches => 10000, :day => Date.civil(2000, 1, 1))
      stat2 = MovieStat.create!(:movie => movie, :seeds => 1, :leaches => 11000, :day => Date.civil(2000, 1, 2))
      stat3 = MovieStat.create!(:movie => movie, :seeds => 1, :leaches => 12000, :day => Date.civil(2000, 1, 3))

      helper.data_points(movie, :leaches).should == "[10.0,11.0,12.0]"
    end  

    it 'should return null for missing date values' do
      movie = Movie.create!(:name => 'test', :year => 2000)
      stat1 = MovieStat.create!(:movie => movie, :seeds => 1, :leaches => 10000, :day => Date.civil(2000, 1, 1))
      stat2 = MovieStat.create!(:movie => movie, :seeds => 1, :leaches => 11000, :day => Date.civil(2000, 1, 4))
      stat3 = MovieStat.create!(:movie => movie, :seeds => 1, :leaches => 12000, :day => Date.civil(2000, 1, 5))

      helper.data_points(movie, :leaches).should == "[10.0,null,null,11.0,12.0]"
    end  

  end  

end
