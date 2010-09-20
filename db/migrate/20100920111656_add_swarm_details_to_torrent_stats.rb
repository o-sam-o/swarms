class AddSwarmDetailsToTorrentStats < ActiveRecord::Migration
  def self.up
    add_column :torrent_stats, :swarm_size, :integer
    add_column :torrent_stats, :latest, :boolean
  end

  def self.down
    remove_column :torrent_stats, :latest
    remove_column :torrent_stats, :swarm_size
  end
end
