class MoviesController < ApplicationController
  
  def show
    @movie = Movie.where(:movie_code => params[:id]).includes(:movie_images, :genres).first
  end

end
