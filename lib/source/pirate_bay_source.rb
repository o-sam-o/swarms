module Source
  class PirateBaySource
    include Source::TorrentSourcer
    include ActionView::Helpers::TextHelper

    YQL_QUERY = %{select * from html where url="http://thepiratebay.se/browse/201/%s/9" and xpath='//table[@id="searchResult"]/tr'}
    TORRENT_URL_XPATH = '//a[starts-with(@href, "/torrent")]/@href'
    SEEDS_XPATH = '//td[3]/p'
    LEACHES_XPATH = '//td[4]/p'
    PAGES_TO_SOURCE = 5
  
    def refresh
      processed_torrents = []
      error_count = 0
    
      (1..PAGES_TO_SOURCE).each do |page|
        Rails.logger.info "Sourcing Pirate Bay page: #{page}"
        xml = yql(YQL_QUERY % (page - 1))
        extract_xpaths(xml, TORRENT_URL_XPATH, SEEDS_XPATH, LEACHES_XPATH) do |torrent_url, seeds, leaches|
          Rails.logger.info "Url: #{torrent_url} Seeds: #{seeds} Leaches: #{leaches}"      
          torrent = torrent_url.split('/').last
          begin
            unless processed_torrents.include?(torrent.downcase)
              record_stats(torrent, seeds, leaches)
              processed_torrents << torrent.downcase
            end
          rescue 
            Rails.logger.error "Error scraping torrent #{torrent} : #{$!}", $!.backtrace
            error_count += 1
          end
        end
      end
    
      "Found #{processed_torrents.length} torrents with #{pluralize(error_count, 'error')}"
    end
  
  end
end  
