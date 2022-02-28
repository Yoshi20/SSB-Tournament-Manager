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

  def federal_states_raw
    ['BB', 'BE', 'BW', 'BY', 'HB', 'HE', 'HH', 'MV', 'NI', 'NW', 'RP', 'SH', 'SL', 'SN', 'ST', 'TH']
  end

  def federal_states
    t(federal_states_raw, scope: 'defines.federal_states')
  end

  def federal_states_for_select
    federal_states.zip(federal_states_raw)
  end

  def departments_raw
    ["Ain", "Aisne", "Allier", "Alpes-de-Haute-Provence", "Hautes-Alpes", "Alpes-Maritimes", "Ardèche", "Ardennes", "Ariège", "Aube", "Aude", "Aveyron", "Bouches-du-Rhône","Calvados", "Cantal", "Charente", "Charente-Maritime", "Cher", "Corrèze", "Corse-du-Sud", "Haute-Corse", "Côte-d'Or", "Côtes-d'Armor", "Creuse", "Dordogne", "Doubs", "Drôme","Eure", "Eure-et-Loir", "Finistère", "Gard", "Haute-Garonne", "Gers", "Gironde", "Hérault", "Ille-et-Vilaine", "Indre", "Indre-et-Loire", "Isère", "Jura", "Landes","Loir-et-Cher", "Loire", "Haute-Loire", "Loire-Atlantique", "Loiret", "Lot", "Lot-et-Garonne", "Lozère", "Maine-et-Loire", "Manche", "Marne", "Haute-Marne", "Mayenne","Meurthe-et-Moselle", "Meuse", "Morbihan", "Moselle", "Nièvre", "Nord", "Oise", "Orne", "Pas-de-Calais", "Puy-de-Dôme", "Pyrénées-Atlantiques", "Hautes-Pyrénées","Pyrénées-Orientales", "Bas-Rhin", "Haut-Rhin", "Rhône", "Lyon_Metropolis", "Haute-Saône", "Saône-et-Loire", "Sarthe", "Savoie", "Haute-Savoie", "Paris", "Seine-Maritime","Seine-et-Marne", "Yvelines", "Deux-Sèvres", "Somme", "Tarn", "Tarn-et-Garonne", "Var", "Vaucluse", "Vendée", "Vienne", "Haute-Vienne", "Vosges", "Yonne", "Territoire_deBelfort", "Essonne", "Hauts-de-Seine", "Seine-Saint-Denis", "Val-de-Marne", "Val-d'Oise", "Guadeloupe", "Martinique", "Guyane", "La_Réunion", "Mayotte"].sort
  end

  def departments
    t(departments_raw, scope: 'defines.departments')
  end

  def departments_for_select
    departments.zip(departments_raw)
  end

  def regions_raw
    ["Auvergne", "Bourgogne", "Bretagne", "Centre", "Corsica", "Grand_Est", "Hauts-de-France", "Ile_de_France", "Normandie", "Nouvelle_Aquitaine", "Occitanie", "Pays_de_la_Loire", "Provence-Alpes-Cote_dAzur"]
  end

  def regions
    t(regions_raw, scope: 'defines.regions')
  end

  def regions_for_select
    regions.zip(regions_raw)
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
