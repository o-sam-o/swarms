class Movie < ActiveRecord::Base
  validates_presence_of :name, :year
  
  has_many :torrents do
    def latest_swarm_count
      self.inject(0) { |result, torrent| result + torrent.torrent_stats.latest.swarm_size }
    end  
  end  
  
  def display_name
    if year
      return "#{name} (#{year})"
    else
      return name
    end
  end  
  
  def self.find_or_create_by_imdb_id(imdb_id)
    logger.info "HERE-----"
    movie = Movie.find_by_imdb_id(imdb_id)
    return movie if movie
    
    logger.info "Creating new movie with imdb id #{imdb_id}"
    imdb_info = Util::ImdbMetadataScraper.scrap_movie_info(imdb_id)
    movie.create!(:name => imdb_info['title'], :year => imdb_info['year'], :imdb_id => imdb_id) 
  end  
end
