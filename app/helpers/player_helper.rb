module PlayerHelper

  def self_assessment_defines
    ['Beginner', 'Noob', 'Doing okay', 'Intermediate', 'Advanced', 'Expert', 'Professional', 'Godlike']
  end

  def tournament_experience_defines
    ['None', 'A little', 'Some', 'A lot', 'Very much']
  end

  def cantons
    ['Aargau', 'Appenzell Ausserrhoden', 'Appenzell Innerrhoden', 'Basel-Land', 'Basel-Stadt', 'Bern', 'Freiburg', 'Genf', 'Glarus', 'Graubünden', 'Jura', 'Luzern', 'Neuenburg', 'Nidwalden', 'Obwalden', 'Schaffhausen', 'Schwyz', 'Solothurn', 'St. Gallen', 'Tessin', 'Thurgau', 'Uri', 'Waadt', 'Wallis', 'Zug', 'Zürich']
  end

  def genders
    ['Male', 'Female', 'Other']
  end

  def birth_years
    year = Date.today.year
    ((year-100)..year).to_a.sort().reverse()
  end

  def top_players_s1_19
    ['Destany', 'DeepFreeze', 'Smuff', 'Severe Calamari', 'Benji', 'Crash', 'Kepler', 'CrzyShroom', 'Sylph', 'Olivia', 'Ryuji', 'Zudenka', 'SickBoy', 'Phonky', 'Radiance', 'Godoh', 'Jesuischoq', 'ItseMePG', 'TunaLink', 'Acsor', 'Rampage', 'N3rthus', 'TheBlerton', 'Fr0zen', 'Karpador64']
  end

end
