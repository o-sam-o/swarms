Then /^I should have the following torrent stats$/ do |expected_table|
  actual_table = [['torrent_name', 'movie_name', 'seeds', 'leaches', 'swarm_size']]
  TorrentStat.all.each { |s| actual_table << [s.torrent.name, s.torrent.movie.name, s.seeds.to_s, s.leaches.to_s, s.swarm_size.to_s] }
  expected_table.diff!(actual_table)
end
