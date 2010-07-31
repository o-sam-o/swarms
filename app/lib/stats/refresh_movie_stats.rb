class Stats::RefreshMovieStats
  
  def self.refresh(start_date=Date.today, end_date=Date.today)
    Rails.logger.info "Refreshing movie stats from #{start_date} till #{end_date}"
    
    (start_date..end_date).each do |day|
      TorrentStat.select("movie_id, sum(seeds) as 'seeds', sum(leaches) as 'leaches'").where(:created_at => day..(day + 1)).joins(:torrent => :movie).group(:movie_id).each do |stat_summary|
        Rails.logger.debug "Setting movie stats for #{stat_summary.movie_id} for #{day}"
        movie_stat = MovieStat.find_or_create_by_movie_id_and_day(stat_summary.movie_id, day)
        movie_stat.update_attributes!(:seeds => stat_summary.seeds, :leaches => stat_summary.leaches)
      end
    end
    
    Rails.logger.info "Movie stats updated"
  end  

end