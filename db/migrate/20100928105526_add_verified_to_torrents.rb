class AddVerifiedToTorrents < ActiveRecord::Migration
  def self.up
    add_column :torrents, :verified, :boolean
    execute "UPDATE torrents set verified = 0"
  end

  def self.down
    remove_column :torrents, :verified
  end
end
