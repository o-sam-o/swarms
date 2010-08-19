class AddMetadataToMovie < ActiveRecord::Migration
  def self.up
    change_table :movies do |t|
      t.string  :director
      t.string  :classification
      t.string  :language
      t.integer :runtime
      t.date    :release_date
      t.integer :current_rank
      t.rename  :description, :plot
    end

    create_table :genres_movies, :id => false do |t|
      t.references :movie
      t.references :genre
    end
    
  end

  def self.down
    change_table :movies do |t|
      t.remove  :director, :classification, :language, :runtime, :release_date, :current_rank
      t.rename  :plot, :description
    end

    drop_table :genres_movies
  end
end
