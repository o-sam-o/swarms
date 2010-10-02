class AddVerifiedToTorrents < ActiveRecord::Migration
  def self.up
    add_column :torrents, :verified, :boolean
    execute "UPDATE torrents set verified = false"
  end

  def self.down
    remove_column :torrents, :verified
  end
end
