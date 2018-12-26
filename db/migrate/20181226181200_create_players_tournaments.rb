class CreatePlayersTournaments < ActiveRecord::Migration[5.2]
  def change
    create_table :players_tournaments, id:false do |t|
      t.belongs_to :player, index: true
      t.belongs_to :tournament, index: true
    end

  end
end
