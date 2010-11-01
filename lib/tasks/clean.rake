desc 'Clean up old movie images'
task :clear_movie_images => :environment do
  posters_dir = "#{Rails.root}/public/images/posters"
  FileUtils.rm_r(posters_dir) rescue p "Unable to delete dir: #{posters_dir}"
end

desc 'Reset and reload torrents'
task :reload_torrents => ['db:reset', :clear_movie_images, :source_torrents]
