class AddIndexes < ActiveRecord::Migration
  def self.up
    add_index :movies, :created_at
    add_index :movies, :imdb_id
    add_index :movies, :swarm_score

    add_index :torrent_stats, :created_at
    
    add_index :torrents, :name
  end

  def self.down
    remove_index :movies, :created_at
    remove_index :movies, :imdb_id
    remove_index :movies, :swarm_score

    remove_index :torrent_stats, :created_at
    
    remove_index :torrents, :name
  end
end
