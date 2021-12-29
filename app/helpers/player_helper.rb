module PlayerHelper

  def self_assessment_defines
    t(['beginner', 'noob', 'doing_okay', 'intermediate', 'advanced', 'expert', 'professional', 'godlike'],
      scope: 'defines.self_assessments')
  end

  def tournament_experience_defines
    t(['none', 'a_little', 'some', 'a_lot', 'very_much'],
      scope: 'defines.tournament_experiences')
  end

  def cantons_raw
    ['aargau', 'appenzell_ausserrhoden', 'appenzell_innerrhoden', 'basel-land', 'basel-stadt', 'bern', 'freiburg', 'genf', 'glarus', 'graubünden', 'jura', 'luzern', 'neuenburg', 'nidwalden', 'obwalden', 'schaffhausen', 'schwyz', 'solothurn', 'st_gallen', 'tessin', 'thurgau', 'uri', 'waadt', 'wallis', 'zug', 'zürich']
  end

  def cantons
    t(cantons_raw, scope: 'defines.cantons')
  end

  def cantons_for_select
    cantons.zip(cantons_raw)
  end

  def genders_raw
    ['male', 'female', 'other']
  end

  def genders
    t(genders_raw, scope: 'defines.genders')
  end

  def genders_for_select
    genders.zip(genders_raw)
  end

  def birth_years
    year = Date.today.year
    ((year-100)..year).to_a.sort().reverse()
  end

  def seed_players(players)
    players.sort_by do |p|
      [p.seed_points, -p.created_at.to_i]
    end.reverse
  end

  def top_players_s1_19
    ['Destany', 'DeepFreeze', 'Smuff', 'Severe Calamari', 'Benji', 'Crash', 'Kepler', 'CrzyShroom', 'Sylph', 'Olivia', 'Ryuji', 'Zudenka', 'SickBoy', 'Phonky', 'Radiance', 'Godoh', 'Jesuischoq', 'ItseMePG', 'TunaLink', 'Acsor', 'Rampage', 'N3rthus', 'TheBlerton', 'Fr0zen', 'Karpador64']
  end

  def top_players_s2_19
    ['Destany', 'Karpador64', 'Crash', 'Phonky', 'DeepFreeze', 'Olivia', 'Kepler', 'SickBoy', 'Jaka', 'ItseMePG', 'Benji', 'Purist', 'Acsor', 'Rampage', 'Yannwatts']
  end

  def top_players_s12_21
    ['Jaka', 'Destany', 'DeepFreeze', 'Deox6', 'Crash', 'Phonky', 'Karpador64', 'Kimbo', 'PATOO', 'colinmee', 'mistic', 'Rohan Doge', 'SickBoy', 'Fr0zen', 'Bigniouf', 'Clipho', 'Mirio', 'Tuzzi', 'ItseMePG', 'Jodel']
  end

end
