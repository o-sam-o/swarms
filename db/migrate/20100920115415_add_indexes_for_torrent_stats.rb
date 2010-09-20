class AddIndexesForTorrentStats < ActiveRecord::Migration
  def self.up
    add_index :torrents, :movie_id
    add_index :torrent_stats, :torrent_id
    add_index :torrent_stats, :latest
  end

  def self.down
    remove_index :torrents, :movie_id
    remove_index :torrent_stats, :torrent_id
    remove_index :torrent_stats, :latest
  end
end
