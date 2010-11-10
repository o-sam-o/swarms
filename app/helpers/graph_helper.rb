module GraphHelper

  def start_point_date(movie)
    date = movie.movie_stats.order(:day).first.day
    "Date.UTC(#{date.year}, #{date.month - 1}, #{date.day})"
  end  

  def movie_stats_range(movie)
    return 0 if movie.movie_stats.blank?

    movie.movie_stats.order(:day).last.day - movie.movie_stats.order(:day).first.day
  end  

  def scale_label(movie)
    "(#{scale_rate(movie).to_i}'s)" unless scale_rate(movie) == 1
  end

  def scale_rate(movie)
    max_stat = movie.movie_stats.maximum(:leaches)
    if max_stat.nil? || max_stat < 10_000
      1
    else
      1000.0
    end
  end  

  def data_points(movie, value_name)
    data = []
    stats = movie.movie_stats.order(:day)
    
    previous_stat = nil
    stats.each do |stat|
      # Add nils for missing days
      (2..((stat.day - previous_stat.day))).each { data << nil } if previous_stat
      
      data << stat.send(value_name) / scale_rate(movie)
      previous_stat =  stat
    end  

    return data.to_json
  end 

  def torrent_info_json(movie)
      m = {}
      movie.torrents.each_with_index { |t, index| m[index] = {'name' => t.name, 
        'created_at' => t.created_at.strftime('%d %b %Y')} }
      m.to_json  
  end  

end  
