class MovieStat < ActiveRecord::Base
  validates_presence_of :movie, :seeds, :leaches, :day
  belongs_to :movie
end
