class HomeController < ApplicationController
  
  def index
    @movies = Movie.includes(:torrents => :torrent_stats).order('swarm_score desc').paginate(:page => params[:page], :per_page => 15)
  end

end
