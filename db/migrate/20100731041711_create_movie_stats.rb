class CreateMovieStats < ActiveRecord::Migration
  def self.up
    create_table :movie_stats do |t|
      t.references :movie
      t.integer :seeds
      t.integer :leaches
      t.date :day

      t.timestamps
    end
  end

  def self.down
    drop_table :movie_stats
  end
end
