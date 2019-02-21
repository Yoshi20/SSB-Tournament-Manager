class UpdateMainCharactersOfExistingPlayers < ActiveRecord::Migration[5.2]
  def up
    Player.where.not(main_characters: []).each do |p|
      p.main_characters.map! { |mc| mc == 'gaogaen' ? 'incineroar' : mc }
      p.main_characters.map! { |mc| mc == 'shizue' ? 'isabelle' : mc }
      p.main_characters.map! { |mc| mc == 'packun_flower' ? 'piranha_plant' : mc }
      p.save!
    end
  end
  def down
    Player.where.not(main_characters: []).each do |p|
      p.main_characters.map! { |mc| mc == 'incineroar' ? 'gaogaen' : mc }
      p.main_characters.map! { |mc| mc == 'isabelle' ? 'shizue' : mc }
      p.main_characters.map! { |mc| mc == 'piranha_plant' ? 'packun_flower' : mc }
      p.save!
    end
  end
end
