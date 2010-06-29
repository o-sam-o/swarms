class Torrent < ActiveRecord::Base
  validates_presence_of :name
  belongs_to :movie
  has_many :torrent_stats do
    def latest
      find(:first, :order => 'created_at DESC')
    end  
  end  
  
  after_create :associate_with_movie
  
  def stats
    torrent_stats
  end
  
  def cleaned_name
    Util::FileNameCleaner.get_name_info(name)
  end  
  
  private
    def associate_with_movie
      return if movie
      name_info = cleaned_name
      year = name_info.year
      if year.present?
        movie = Movie.find_by_name_and_year(name_info.name, year)
      else
        movie = Movie.find_by_name(name_info.name)
      end
      
      unless movie
        logger.info "Searching imdb for #{name_info.name} (#{name_info.year})"
        imdb_id = Util::ImdbMetadataScraper.search_for_imdb_id(name_info.name, name_info.year)
        if imdb_id.present?
          logger.info "Found imdb id #{imdb_id} for #{name_info.name} (#{name_info.year})"
          movie = Movie.find_or_create_by_imdb_id(imdb_id)
        else
          logger.warn "Couldn't find imdb id for #{name_info.name} (#{name_info.year})"
        end
      end  
    end  
end
