class AddCountryCodeToAlternativeGamerTags < ActiveRecord::Migration[5.2]
  def change
    add_column :alternative_gamer_tags, :country_code, :string
    AlternativeGamerTag.includes(:player).all.each do |agt|
      if agt.respond_to?(:country_code)
        agt.update(country_code: agt.player.country_code)
      end
    end
  end
end
