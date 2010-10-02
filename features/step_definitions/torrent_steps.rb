Given /^the following torrents exist:$/ do |table|
  table.map_column!('movie', false) { |name| Movie.find_by_name(name) }
  
  Torrent.create!(table.hashes) 
end
