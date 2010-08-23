class AddPreviousScoreToMovies < ActiveRecord::Migration
  def self.up
    add_column :movies, :previous_swarm_score, :integer
  end

  def self.down
    remove_column :movies, :previous_swarm_score
  end
end
