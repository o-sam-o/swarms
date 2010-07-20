class Movie < ActiveRecord::Base
  validates_presence_of :name, :year
  
  has_many :torrents do
    def latest_swarm_count
      self.inject(0) { |result, torrent| result + torrent.stats.latest.swarm_size }
    end  
    def latest_leaches_count
      self.inject(0) { |result, torrent| result + torrent.stats.latest.leaches }
    end    
    def latest_seeds_count
      self.inject(0) { |result, torrent| result + torrent.stats.latest.seeds }
    end    
  end  
  
  has_many :movie_images do
    def small
      self.select { |i| i.format == 'small' }.first
    end  
  end
  
  def images
    movie_images
  end  
  
  def display_name
    year? ? "#{name} (#{year})" : name
  end  
  
  def update_swarm_score(after)
    latest_stats = Movie.joins(:torrents => :torrent_stats).where("movies.id = ? and torrent_stats.created_at >= ?", self.id, after)
    update_attribute(:swarm_score, latest_stats.sum(:seeds) + latest_stats.sum(:leaches))
  end  
  
  def self.find_or_create_by_imdb_id(imdb_id)
    movie = Movie.find_by_imdb_id(imdb_id)
    return movie if movie
    
    imdb_info = YayImdbs.scrap_movie_info(imdb_id)
    logger.info "Creating new movie with imdb id #{imdb_id}"
    self.create_from_imdb_info(imdb_info, imdb_id)
  end  
  
  def self.create_from_imdb_info(imdb_info, imdb_id)
    movie = Movie.create!(:name => imdb_info['title'], :year => imdb_info['year'], :imdb_id => imdb_id) 
    
    MovieImage.download_image(imdb_info[:small_image], movie, :small) if imdb_info[:small_image]
    MovieImage.download_image(imdb_info[:large_image], movie, :poster) if imdb_info[:large_image]
    
    return movie  
  end  
end
