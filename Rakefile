# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)
require 'rake'

Swarm::Application.load_tasks

desc 'Update popular torrents'
task :source_torrents => :environment do
  p 'Sourcing torrents ...'
  p Source::TorrentSource.update
  p 'Done.'
end

desc 'Add movie stats from when lasted added until today'
task :add_movie_stats => :environment do
  last_refresh = MovieStat.order('day DESC').first.day rescue Date.civil(2010, 8, 1)
  p "Generating movie stats since #{last_refresh}"
  Stats::RefreshMovieStats.refresh(last_refresh, Date.today)
  p 'Done.'
end

desc 'Clean up old movie images'
task :clear_movie_images => :environment do
  posters_dir = "#{Rails.root}/public/images/posters"
  FileUtils.rm_r(posters_dir) rescue p "Unable to delete dir: #{posters_dir}"
end

desc 'Reset and reload torrents'
task :reload_torrents => ['db:reset', :clear_movie_images, :source_torrents]
