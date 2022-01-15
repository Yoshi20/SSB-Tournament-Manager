class UpdateCantonsAndGendersOfExistingPlayers < ActiveRecord::Migration[5.2]
  def cantons_lut
    [["Aargau", "aargau"], ["Appenzell Ausserrhoden", "appenzell_ausserrhoden"], ["Appenzell Innerrhoden", "appenzell_innerrhoden"], ["Basel-Land", "basel-land"], ["Basel-Stadt", "basel-stadt"], ["Bern", "bern"], ["Freiburg", "freiburg"], ["Genf", "genf"], ["Glarus", "glarus"], ["Graubünden", "graubünden"], ["Jura", "jura"], ["Luzern", "luzern"], ["Neuenburg", "neuenburg"], ["Nidwalden", "nidwalden"], ["Obwalden", "obwalden"], ["Schaffhausen", "schaffhausen"], ["Schwyz", "schwyz"], ["Solothurn", "solothurn"], ["St. Gallen", "st_gallen"], ["Tessin", "tessin"], ["Thurgau", "thurgau"], ["Uri", "uri"], ["Waadt", "waadt"], ["Wallis", "wallis"], ["Zug", "zug"], ["Zürich", "zürich"]]
  end
  def genders_lut
    [["Male", "male"], ["Female", "female"], ["Other", "other"]]
  end
  def up
    Player.all_ch.each do |p|
      if !p.canton.nil? && !p.canton.empty?
        cantons_lut.each do |c|
          if c[0] == p.canton
            p.canton = c[1]
            break
          end
        end
      end
      if !p.gender.nil? && !p.gender.empty?
        genders_lut.each do |g|
          if g[0] == p.gender
            p.gender = g[1]
            break
          end
        end
      end
      p.save!
    end
  end
  def down
    Player.all_ch.each do |p|
      if !p.canton.nil? && !p.canton.empty?
        cantons_lut.each do |c|
          if c[1] == p.canton  # c = [Bern, bern]
            p.canton = c[0]
            break
          end
        end
      end
      if !p.gender.nil? && !p.gender.empty?
        genders_lut.each do |g|
          if g[1] == p.gender  # g = [Männlich, male]
            p.gender = g[0]
            break
          end
        end
      end
      p.save!
    end
  end
end
