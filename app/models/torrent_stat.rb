class TorrentStat < ActiveRecord::Base
  validates_presence_of :torrent, :seeds, :leaches
  belongs_to :torrent
  
  def swarm_size
    seeds + leaches
  end  
end
