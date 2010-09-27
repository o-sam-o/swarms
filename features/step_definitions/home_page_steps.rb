Then /^the (\d+)(?:st|nd|rd|th) movie should be "([^"]*)"$/ do |index, movie_title|
  within ".movie_tiles li:nth-child(#{index})" do
    assert page.has_content?(movie_title)
  end
end

Then /^I should see (\d+) movies$/ do |count|
  page.should have_css('.movie_tiles li', :count => count.to_i)
end
