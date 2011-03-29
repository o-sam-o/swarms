class SetTorrentVerifiedDefault < ActiveRecord::Migration
  def self.up
    change_column :torrents, :verified, :boolean, {:default => false}
  end

  def self.down
    change_column :torrents, :verified, :boolean
  end
end
