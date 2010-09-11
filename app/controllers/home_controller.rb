class HomeController < ApplicationController
  
  def index
    @movies = Movie.includes(:torrents => :torrent_stats)
                   .where('current_rank != 0')
                   .order('current_rank')
                   .paginate(:page => params[:page], :per_page => 15)

    @featured_movie = Movie.where('current_rank != 0').order('current_rank').first
  end

end
