Given /^the following torrents exist:$/ do |table|
  table.map_column!('movie', false) { |name| Movie.find_by_name(name) }
  
  Torrent.create!(table.hashes) 
end

Then /^I should have the following torrents:$/ do |expected_table|
  actual_table = [['name', 'movie', 'verified']]
  Torrent.all.each { |t| actual_table << [t.name, t.movie.name, t.verified.to_s] }
  expected_table.diff!(actual_table)
end

