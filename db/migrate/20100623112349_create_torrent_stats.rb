class CreateTorrentStats < ActiveRecord::Migration
  def self.up
    create_table :torrent_stats do |t|
      t.integer :seeds
      t.integer :leaches
      t.references :torrent

      t.timestamps
    end
  end

  def self.down
    drop_table :torrent_stats
  end
end
