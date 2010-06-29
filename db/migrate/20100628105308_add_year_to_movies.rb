class AddYearToMovies < ActiveRecord::Migration
  def self.up
    add_column :movies, :year, :integer
  end

  def self.down
    remove_column :movies, :year
  end
end
