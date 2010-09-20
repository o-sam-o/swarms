class TorrentStat < ActiveRecord::Base
  validates_presence_of :torrent, :seeds, :leaches
  belongs_to :torrent
  
  before_save :set_swarm_size

  def set_swarm_size
    self.swarm_size = seeds + leaches
  end  
end
