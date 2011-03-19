desc 'Update popular torrents'
task :source_torrents => :environment do
  p 'Sourcing torrents ...'
  p Source::TorrentSource.update
  p 'Done.'
end

desc 'Refresh all movie data from IMDB'
task :refresh_all_torrents, :force_images, :needs => :environment do |t, args|
  force_image_refresh = args && args[:force_images] == 'true'
  movie_count = Movie.count
  p "Refreshing #{movie_count} movies info #{'and images ' if force_image_refresh }from imdb"
  
  movies_processed = 0
  errors = 0
  print "0%"
  Movie.find_in_batches(:batch_size => 100) do |batch|
    batch.each do |movie|
      begin
        begin
          movie.refresh_from_imdb!(force_image_refresh)
        rescue
          # Might have been done for scraping, sleep a bit and try again
          sleep 10
          movie.refresh_from_imdb!(force_image_refresh)
        end
        movies_processed += 1

        print "\b\b\b\b\b\b#{"%.2f" % ((movies_processed.to_f / movie_count.to_f) * 100)}%"
        sleep 1
      rescue Exception => e
        p "Failed to scrap movie #{movie.name} [#{movie.id}] : #{e.message}"
        errors += 1
      end
    end
    sleep 60
  end

  p "Finished with #{errors} errors"
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



