class CreateJoinTablePlayersTeams < ActiveRecord::Migration[5.2]
  def change
    create_join_table :players, :teams do |t|
      # t.index [:player_id, :team_id]
      # t.index [:team_id, :player_id]
    end
  end
end
