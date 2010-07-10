class HomeController < ApplicationController
  def index
    @movies = Movie.all
  end

end
