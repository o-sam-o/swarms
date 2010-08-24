module Source
  module TorrentSourcer

    def yql(query)
      Rails.logger.info 'querying via YQL'
    
      uri = "http://query.yahooapis.com/v1/public/yql"
      response = Net::HTTP.post_form( URI.parse( uri ), {
        'q' => query,
        'format' => 'xml'
      } )
    
      Rails.logger.info 'got yql result'
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

  end  
end