class MoviesController < ApplicationController
  
  def show
    @movie = Movie.where(:movie_code => params[:id]).includes(:movie_images, :genres).first
    @torrents = @movie.torrents.order("created_at DESC").paginate(:page => params[:page], :per_page => 10)
  end

  def id
    redirect_to Movie.find(params[:id])
  end

end
