class Movie < ActiveRecord::Base
  validates_presence_of :name, :year
  validates_uniqueness_of :name, :scope => :year, :case_sensitive => false
  validates_uniqueness_of :movie_code
  
  before_update :set_previous_score
  before_create :set_movie_code

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
    def poster
      self.select { |i| i.format == 'poster' }.first
    end    
  end
  
  has_many :movie_stats
  has_and_belongs_to_many :genres
 
  scope :imageless, lambda { 
    joins('left join movie_images on movie_images.movie_id = movies.id').where('movie_images.id is null')
  } 

  def images
    movie_images
  end  
  
  def display_name
    year? ? "#{name} (#{year})" : name
  end  
  
  def set_previous_score 
    self.previous_swarm_score = swarm_score_was if swarm_score_changed?
  end

  def set_movie_code
    return if self.movie_code

    raw_code = "#{name.downcase.gsub(/\s/, '-').gsub(/[^a-z0-9\-]/, '')}-#{year}"
    code = raw_code
    n = 2
    while Movie.exists?(:movie_code => code) 
      code = "#{raw_code}-#{n}"
      n = n + 1
    end
    self.movie_code = code
  end  

  def to_param
    movie_code
  end


  def swarm_score_up?
   swarm_score? && previous_swarm_score? && swarm_score > previous_swarm_score
  end 

  def swarm_score_down?
    swarm_score? && previous_swarm_score? && swarm_score < previous_swarm_score
  end  

  def latest_torrent_stats
    @latest_torrent_stats ||= TorrentStat.joins(:torrent)
                                         .where('torrents.movie_id' => self.id, :latest => true)
                                         .order('swarm_size')
  end  

  def update_swarm_score(after)
    latest_stats = Movie.joins(:torrents => :torrent_stats).where("movies.id = ? and torrent_stats.created_at >= ?", self.id, after)
    update_attribute(:swarm_score, latest_stats.sum(:seeds) + latest_stats.sum(:leaches))
  end  
  
  def refresh_from_imdb!(force_image_refresh=false)
    raise "Unable to refresh #{self.id} as no imdb id" if self.imdb_id.blank?
    
    imdb_info = YayImdbs.scrap_movie_info(self.imdb_id)
    self.update_attributes!(Movie.convert_imdb_info_to_params(imdb_info, self.imdb_id))

    if force_image_refresh || images.empty?
      MovieImage.download_image(imdb_info[:small_image], self, :small) if imdb_info[:small_image]
      MovieImage.download_image(imdb_info[:large_image], self, :poster) if imdb_info[:large_image]
    end
  end 

  def self.find_or_create_by_imdb_id(imdb_id)
    movie = Movie.find_by_imdb_id(imdb_id)
    return movie if movie
    
    imdb_info = YayImdbs.scrap_movie_info(imdb_id)
    logger.info "Creating new movie with imdb id #{imdb_id}"
    self.create_from_imdb_info(imdb_info, imdb_id)
  end  
  
  def self.create_from_imdb_info(imdb_info, imdb_id)
    movie = Movie.create!(self.convert_imdb_info_to_params(imdb_info, imdb_id)) 
    
    MovieImage.download_image(imdb_info[:small_image], movie, :small) if imdb_info[:small_image]
    MovieImage.download_image(imdb_info[:large_image], movie, :poster) if imdb_info[:large_image]
    
    return movie  
  end

private

  def self.convert_imdb_info_to_params(imdb_info, imdb_id)
    {
     :name => imdb_info[:title], :year => imdb_info[:year], :plot => imdb_info[:plot],
     :director => imdb_info[:director], :language => imdb_info[:languages].try(:join, ', '), 
     :classification => imdb_info[:mpaa], :release_date => imdb_info[:release_date],
     :genres => imdb_info[:genre].blank? ? [] : imdb_info[:genre].collect{|name| Genre.find_or_create_by_name(name)},
     :runtime => imdb_info[:runtime], :imdb_id => imdb_id
    }
  end 

end
