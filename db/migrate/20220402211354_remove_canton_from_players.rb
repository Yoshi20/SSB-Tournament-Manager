class RemoveCantonFromPlayers < ActiveRecord::Migration[5.2]
  def up
    Player.where(country_code: 'ch').where.not(canton: nil).each do |p|
      p.update(region: p.canton)
    end
    remove_column :players, :canton

    Player.where(country_code: 'de').where.not(federal_state: nil).each do |p|
      p.update(region: p.federal_state)
    end
    remove_column :players, :federal_state

    Tournament.where(country_code: 'ch').where.not(canton: nil).each do |t|
      t.update(region: t.canton)
    end
    remove_column :tournaments, :canton

    Tournament.where(country_code: 'de').where.not(federal_state: nil).each do |t|
      t.update(region: t.federal_state)
    end
    remove_column :tournaments, :federal_state
  end

  def down
    add_column :players, :canton, :string
    Player.where(country_code: 'ch').where.not(region: nil).each do |p|
      p.update(canton: p.region)
    end

    add_column :players, :federal_state, :string
    Player.where(country_code: 'de').where.not(region: nil).each do |p|
      p.update(federal_state: p.region)
    end

    add_column :tournaments, :canton, :string
    Tournament.where(country_code: 'ch').where.not(region: nil).each do |t|
      t.update(canton: t.region)
    end

    add_column :tournaments, :federal_state, :string
    Tournament.where(country_code: 'de').where.not(region: nil).each do |t|
      t.update(federal_state: t.region)
    end
  end
end
