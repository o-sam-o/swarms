module Source 
  class TorrentSource

    def self.update
      started_at = Time.now
        
      source = Source::PirateBaySource.new
      result = source.refresh
      Rails.logger.info "PirateBay Scrap complete, took: #{Time.now - started_at}s"
      scrap_time = Time.now

      Rails.logger.info "Updating movie swarm scores"
      Movie.find_each do |movie|
        movie.update_swarm_score(started_at)
      end
      Rails.logger.info "Update swarm scores complete, took: #{Time.now - scrap_time}"

      rank = 1
      Movie.where('swarm_score != 0').order('swarm_score DESC').each do |movie|
        movie.update_attribute(:current_rank, rank)
        rank += 1
      end
    
      # Remove rank for any movie that doesnt current have a score
      Movie.update_all "current_rank = null", "swarm_score = 0"

      # Update latest torrent stats flag
      TorrentStat.update_all({:latest => false}, ["created_at < ?", started_at])
      TorrentStat.update_all({:latest => true}, ["created_at >= ?", started_at])

      Rails.logger.info "Finished in #{Time.now - started_at}s"
      return result
    end  

  end
end
