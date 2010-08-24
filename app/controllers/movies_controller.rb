class MoviesController < ApplicationController
  
  def show
    @movie = Movie.find_by_movie_code(params[:id])
  end

end
