desc 'Add movie stats from when lasted added until today'
task :add_movie_stats => :environment do
  last_refresh = MovieStat.order('day DESC').first.day rescue Date.civil(2010, 8, 1)
  p "Generating movie stats since #{last_refresh}"
  Stats::RefreshMovieStats.refresh(last_refresh, Date.today)
  p 'Done.'
end
