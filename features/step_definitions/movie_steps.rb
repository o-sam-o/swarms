Given /^the following movies exist:$/ do |table|
  table.map_column!('genres', false) { |name| [Genre.find_or_create_by_name(name)] }
  
  Movie.create!(table.hashes) 
end

Given /^there are (\d+) movies$/ do |count|
  (1..count.to_i).each do |index|
    Movie.create!(:name => "Movie Ranked #{index}", :year => 2000, :current_rank => index)
  end
end

