class MoviesController < ApplicationController
  
  def show
    @movie = Movie.where(:movie_code => params[:id]).includes(:movie_images, :genres).first
    @torrents = @movie.torrents.paginate(:page => params[:page], :per_page => 10)
  end

end
