
When /^I source torrents$/ do
  Source::TorrentSource.update
end


Given /^I stub the pirate bay scraper to find$/ do |table|
  pb_source = Source::PirateBaySource.new
  Source::PirateBaySource.stub(:new).and_return(pb_source)
  pb_source.stub(:yql).and_return('dummy_pb_xml')
  stubbed_xpath = pb_source.stub(:extract_xpaths)
  table.raw[1..-1].each do |result|
    stubbed_xpath.and_yield(*result)
  end
end

Given /^I stub IMDB to have the following movies$/ do |table|
  table.hashes.each_with_index do |movie_hash, index|
    fake_id = "fake_imdb_id_#{index}"
    YayImdbs.stub(:search_for_imdb_id).with(movie_hash[:title], movie_hash[:year].to_i).and_return(fake_id)
    YayImdbs.stub(:scrap_movie_info).with(fake_id).and_return(
      {
        :plot => 'stubbed plot',
        :director => 'stubbed director', :language => ['English'], 
        :classification => 'R', :release_date => index.days.ago,
        :genres => ['Action'],
        :runtime => 100, :imdb_id => fake_id
      }.with_indifferent_access.merge(movie_hash)
    )
  end
end

