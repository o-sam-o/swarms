class AddMovieCodeToMovies < ActiveRecord::Migration
  def self.up
    add_column :movies, :movie_code, :string
  end

  def self.down
    remove_column :movies, :movie_code
  end
end
