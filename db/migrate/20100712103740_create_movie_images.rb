class CreateMovieImages < ActiveRecord::Migration
  def self.up
    create_table :movie_images do |t|
      t.references :movie
      t.string :file_name
      t.string :format
      t.integer :width
      t.integer :height

      t.timestamps
    end
  end

  def self.down
    drop_table :movie_images
  end
end
