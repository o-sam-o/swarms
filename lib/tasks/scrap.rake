desc 'Update popular torrents'
task :source_torrents => :environment do
  p 'Sourcing torrents ...'
  p Source::TorrentSource.update
  p 'Done.'
end

desc 'Retry poster download from imdb where posters are missing'
task :retry_missing_posters => :environment do
  p 'Retrying missing poster download'
  Movie.imageless.find_each do |movie|
    p "Trying to get images for #{movie.display_name}"
    movie = Movie.find(movie.id)
    movie.refresh_from_imdb!
    if movie.images.reload.empty?
      p "Still no poster"
    else
      p "Found posters!"
    end
  end  
  p 'Done.'
end



