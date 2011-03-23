Given /^the following movies exist:$/ do |table|
  table.map_column!('genres', false) { |name| [Genre.find_or_create_by_name(name)] }
  
  Movie.create!(table.hashes) 
end

Given /^there are (\d+) movies$/ do |count|
  (1..count.to_i).each do |index|
    Movie.create!(:name => "Movie Ranked #{index}", :year => 2000, :current_rank => index)
  end
end

Then /^I should have the follow movies$/ do |expected_table|
  actual_table = [['movie_name', 'movie_year', 'swarm_score', 'current_rank']]
  Movie.all.each { |m| actual_table << [m.name, m.year.to_s, m.swarm_score.to_s, m.current_rank.to_s] }
  expected_table.diff!(actual_table)
end

