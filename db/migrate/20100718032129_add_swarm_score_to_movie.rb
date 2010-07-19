class AddSwarmScoreToMovie < ActiveRecord::Migration
  def self.up
    add_column :movies, :swarm_score, :integer
  end

  def self.down
    remove_column :movies, :swarm_score
  end
end
