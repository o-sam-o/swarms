module Source
  class PirateBaySource
    include Source::TorrentSourcer
  
    YQL_QUERY = %{select * from html where url="http://thepiratebay.org/browse/201/%s/9" and xpath='//table[@id="searchResult"]/tr'}
    TORRENT_URL_XPATH = '//a[starts-with(@href, "http://torrents.thepiratebay.org")]/@href'
    SEEDS_XPATH = '//td[3]/p'
    LEACHES_XPATH = '//td[4]/p'
    PAGES_TO_SOURCE = 5
  
    def refresh
      torrent_count = 0
    
      (1..PAGES_TO_SOURCE).each do |page|
        Rails.logger.info "Sourcing Pirate Bay page: #{page}"
        xml = yql(YQL_QUERY % (page - 1))
        extract_xpaths(xml, TORRENT_URL_XPATH, SEEDS_XPATH, LEACHES_XPATH) do |torrent_url, seeds, leaches|
          Rails.logger.info "Url: #{torrent_url} Seeds: #{seeds} Leaches: #{leaches}"      
          torrent = torrent_url.split('/').last
          record_stats(torrent, seeds, leaches)
          torrent_count += 1
        end
      end
    
      "Found #{torrent_count} torrents"
    end
  
  end
end  