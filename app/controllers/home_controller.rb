class HomeController < ApplicationController
  def index
    @movies = Movie.joins(:torrents => :torrent_stats).group("movies.id").order('sum(torrent_stats.leaches) desc').all
  end

end
