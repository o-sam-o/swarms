# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)
require 'rake'

Rails::Application.load_tasks

desc 'Update popular torrents'
task :source_torrents => :environment do
  p 'Sourcing torrents ...'
  p TorrentSource.update
  p 'Done.'
end