Then /^I should see "([^"]*)" in the change movie results$/ do |text|
  Then %{I should see "#{text}" within "#change-movie-table"}
end

When /^I use the "([^"]*)" change movie result$/ do |movie_name|
  Then %{I follow "#use_movie_#{ movie_name.gsub(/\s/, '') }"}
end

When /^I opt to change the movie matching the torrent "([^"]*)"$/ do |torrent_name|
  torrent = Torrent.find_by_name(torrent_name)
  Then %{I press "Change" within "#match_row_for_#{torrent.id}"}
end

When /^I press "([^"]*)" on the change movie dialog$/ do |button_label|
  Then %{I press "#{button_label}" within "#change-movie-dialog"}
end
