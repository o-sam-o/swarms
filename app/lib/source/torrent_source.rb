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

      rank = 1
      Movie.where('swarm_score != 0').order('swarm_score DESC').each do |movie|
        movie.update_attribute(:current_rank, rank)
        rank += 1
      end
    
      # Remove rank for any movie that doesnt current have a score
      Movie.update_all "current_rank = null", "swarm_score = 0"

      Rails.logger.info "Finished in #{Time.now - started_at}s"
      return result
    end  

  end
end
