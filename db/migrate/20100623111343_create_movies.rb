class CreateMovies < ActiveRecord::Migration
  def self.up
    create_table :movies do |t|
      t.string :name
      t.text :description
      t.string :imdb_id

      t.timestamps
    end
  end

  def self.down
    drop_table :movies
  end
end
