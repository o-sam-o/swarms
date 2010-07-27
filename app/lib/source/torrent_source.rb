module Source 
  class TorrentSource

    def self.update
      started_at = Time.now
        
      source = Source::PirateBaySource.new
      result = source.refresh
    
      Rails.logger.info "Updating movie swarm scores"
      Movie.find_each do |movie|
        movie.update_swarm_score(started_at)
      end
    
      Rails.logger.info "Finished in #{Time.now - started_at}s"
      return result
    end  

  end
end