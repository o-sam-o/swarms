class Movie < ActiveRecord::Base
  validates_presence_of :name, :year
  
  has_many :torrents do
    def latest_swarm_count
      self.inject(0) { |result, torrent| result + torrent.stats.latest.swarm_size }
    end  
  end  
  
  def display_name
    year? ? "#{name} (#{year})" : name
  end  
  
  def self.find_or_create_by_imdb_id(imdb_id)
    movie = Movie.find_by_imdb_id(imdb_id)
    return movie if movie
    
    logger.info "Creating new movie with imdb id #{imdb_id}"
    imdb_info = Util::ImdbMetadataScraper.scrap_movie_info(imdb_id)
    Movie.create!(:name => imdb_info['title'], :year => imdb_info['year'], :imdb_id => imdb_id) 
  end  
end
