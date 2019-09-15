module PlayerHelper

  def self_assessment_defines
    t(['beginner', 'noob', 'doing_okay', 'intermediate', 'advanced', 'expert', 'professional', 'godlike'],
      scope: 'defines.self_assessments')
  end

  def tournament_experience_defines
    t(['none', 'a_little', 'some', 'a_lot', 'very_much'],
      scope: 'defines.tournament_experiences')
  end

  def cantons
    t(['aargau', 'appenzell_outer', 'appenzell_inner', 'basel_land', 'basel_city', 'bern', 'friborg', 'geneva', 'glarus', 'graubünden', 'jura', 'lucerne', 'neuchâtel', 'nidwalden', 'obwalden', 'schaffhausen', 'schwyz', 'solothurn', 'st_gallen', 'ticino', 'thurgau', 'uri', 'vaud', 'valais', 'zug', 'zurich'],
      scope: 'defines.cantons')
  end

  def genders
    t(['male', 'female', 'other'],
      scope: 'defines.genders')
  end

  def birth_years
    year = Date.today.year
    ((year-100)..year).to_a.sort().reverse()
  end

  def top_players_s1_19
    ['Destany', 'DeepFreeze', 'Smuff', 'Severe Calamari', 'Benji', 'Crash', 'Kepler', 'CrzyShroom', 'Sylph', 'Olivia', 'Ryuji', 'Zudenka', 'SickBoy', 'Phonky', 'Radiance', 'Godoh', 'Jesuischoq', 'ItseMePG', 'TunaLink', 'Acsor', 'Rampage', 'N3rthus', 'TheBlerton', 'Fr0zen', 'Karpador64']
  end

end
