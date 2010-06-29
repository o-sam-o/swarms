class TorrentSource

  def yql(query)
    uri = "http://query.yahooapis.com/v1/public/yql"

    response = Net::HTTP.post_form( URI.parse( uri ), {
      'q' => query,
      'format' => 'xml'
    } )

    return response.body
  end

  def extract_xpaths(xml, *xpaths)
    document = Nokogiri::HTML.parse(xml)
    results = xpaths.map { |xpath| document.xpath(xpath) }
    
    (0..results.first.size - 1).each do |index| 
      output = results.map { |result| result[index].respond_to?(:content) ? result[index].content : result[index] }
      yield output.size == 1 ? output.first : output
    end 
  end

  def record_stats(torrent, seeds, leaches)
    torrent = Torrent.find_or_create_by_name(torrent)
    torrent.stats.create!(:seeds => seeds, :leaches => leaches)
  end  

  def refresh
    Rails.logger.info 'querying via YQL'
    xml = yql(%{select * from html where url="http://thepiratebay.org/browse/201/0/9" and xpath='//table[@id="searchResult"]/tr'})
    Rails.logger.info 'got yql result'
    torrent_count = 0
    extract_xpaths(xml, '//a[starts-with(@href, "http://torrents.thepiratebay.org")]/@href', '//td[3]/p', '//td[4]/p') do |torrent_url, seeds, leaches|
      Rails.logger.info "Url: #{torrent_url} Seeds: #{seeds} Leaches: #{leaches}"      
      torrent = torrent_url.split('/').last
      record_stats(torrent, seeds, leaches)
      torrent_count += 1
    end
    "Found #{torrent_count} torrents"
  end  

  def self.update
    source = TorrentSource.new
    result = source.refresh
    Rails.logger.info 'finished'
    return result
  end  

end