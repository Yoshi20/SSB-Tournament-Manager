module PlayerHelper

  def self_assessment_defines
    t(['beginner', 'noob', 'doing_okay', 'intermediate', 'advanced', 'expert', 'professional', 'godlike'],
      scope: 'defines.self_assessments')
  end

  def tournament_experience_defines
    t(['none', 'a_little', 'some', 'a_lot', 'very_much'],
      scope: 'defines.tournament_experiences')
  end

  def regions_raw_from(country_code)
    if country_code == 'ch'
      ['aargau', 'appenzell_ausserrhoden', 'appenzell_innerrhoden', 'basel-land', 'basel-stadt', 'bern', 'freiburg', 'genf', 'glarus', 'graubünden', 'jura', 'luzern', 'neuenburg', 'nidwalden', 'obwalden', 'schaffhausen', 'schwyz', 'solothurn', 'st_gallen', 'tessin', 'thurgau', 'uri', 'waadt', 'wallis', 'zug', 'zürich']
    elsif country_code == 'de'
      ['BB', 'BE', 'BW', 'BY', 'HB', 'HE', 'HH', 'MV', 'NI', 'NW', 'RP', 'SH', 'SL', 'SN', 'ST', 'TH']
    elsif country_code == 'fr'
      ["Auvergne", "Bourgogne", "Bretagne", "Centre", "Corsica", "Grand_Est", "Hauts-de-France", "Ile_de_France", "Normandie", "Nouvelle_Aquitaine", "Occitanie", "Pays_de_la_Loire", "Provence-Alpes-Cote_dAzur", "Reunion", "Martinique", "Guyane", "Guadeloupe", "Mayotte", "Collectivite_dOutre-Mer"]
    elsif country_code == 'lu'
      ['capellen', 'clervaux', 'diekirch', 'echternach', 'esch', 'grevenmacher', 'luxembourg', 'mersch', 'redange', 'remich', 'vianden', 'wiltz', 'belgium', 'france', 'germany']
    elsif country_code == 'it'
      ['abruzzo', 'aosta_valley', 'apulia', 'basilicata', 'calabria', 'campania', 'emilia-romagna', 'friuli_venezia_giulia', 'lazio', 'liguria', 'lombardy', 'marche', 'molise', 'piemont', 'sardinia', 'sicily', 'trentino-south_tyrol', 'tuscany', 'umbria', 'veneto']
    elsif country_code == 'uk'
      ['south_east', 'london', 'north_west', 'east_of_england', 'midlands', 'south_west', 'yorkshire_and_the_humber', 'north_east', 'northern_ireland', 'scotland', 'wales', 'ireland']
    elsif country_code == 'pt'
      ['aveiro', 'azores', 'beja', 'braga', 'braganca', 'castelo_branco', 'coimbra', 'evora', 'faro', 'guarda', 'leiria', 'lisbon', 'madeira', 'portalegre', 'porto', 'santarem', 'setubal', 'viana_do_castelo', 'vila_real', 'viseu']
    elsif country_code == 'is'
      ['south', 'east', 'north_east', 'north_west', 'westfjords', 'west', 'reykjanes', 'reykjavik']
    end
  end

  def regions_from(country_code)
    t(regions_raw_from(country_code), scope: 'defines.regions')
  end

  def regions_for_select_from(country_code)
    regions_from(country_code).zip(regions_raw_from(country_code))
  end

  def departments_raw
    ["Ain", "Aisne", "Allier", "Alpes-de-Haute-Provence", "Hautes-Alpes", "Alpes-Maritimes", "Ardèche", "Ardennes", "Ariège", "Aube", "Aude", "Aveyron", "Bouches-du-Rhône","Calvados", "Cantal", "Charente", "Charente-Maritime", "Cher", "Corrèze", "Corse-du-Sud", "Haute-Corse", "Côte-d'Or", "Côtes-d'Armor", "Creuse", "Dordogne", "Doubs", "Drôme","Eure", "Eure-et-Loir", "Finistère", "Gard", "Haute-Garonne", "Gers", "Gironde", "Hérault", "Ille-et-Vilaine", "Indre", "Indre-et-Loire", "Isère", "Jura", "Landes","Loir-et-Cher", "Loire", "Haute-Loire", "Loire-Atlantique", "Loiret", "Lot", "Lot-et-Garonne", "Lozère", "Maine-et-Loire", "Manche", "Marne", "Haute-Marne", "Mayenne","Meurthe-et-Moselle", "Meuse", "Morbihan", "Moselle", "Nièvre", "Nord", "Oise", "Orne", "Pas-de-Calais", "Puy-de-Dôme", "Pyrénées-Atlantiques", "Hautes-Pyrénées","Pyrénées-Orientales", "Bas-Rhin", "Haut-Rhin", "Rhône", "Lyon_Metropolis", "Haute-Saône", "Saône-et-Loire", "Sarthe", "Savoie", "Haute-Savoie", "Paris", "Seine-Maritime","Seine-et-Marne", "Yvelines", "Deux-Sèvres", "Somme", "Tarn", "Tarn-et-Garonne", "Var", "Vaucluse", "Vendée", "Vienne", "Haute-Vienne", "Vosges", "Yonne", "Territoire_deBelfort", "Essonne", "Hauts-de-Seine", "Seine-Saint-Denis", "Val-de-Marne", "Val-d'Oise", "Guadeloupe", "Martinique", "Guyane", "La_Réunion", "Mayotte"].sort
  end

  def counties_of_england
    {
      "Bedfordshire": "east_of_england",
      "Cambridgeshire": "east_of_england",
      "Essex": "east_of_england",
      "Hertfordshire": "east_of_england",
      "Norfolk": "east_of_england",
      "Suffolk": "east_of_england",
      "East Anglia": "east_of_england",
      "Peterborough": "east_of_england",
      "Luton": "east_of_england",
      "Bedford": "east_of_england",
      "Central Bedfordshire": "east_of_england",
      "Southend-on-Sea": "east_of_england",
      "Thurrock": "east_of_england",
      "Derbyshire": "midlands",
      "Leicestershire": "midlands",
      "Lincolnshire": "midlands",
      "Northamptonshire": "midlands",
      "Nottingham": "midlands",
      "Nottinghamshire": "midlands",
      "Rutland": "midlands",
      "Herefordshire": "midlands",
      "Shropshire": "midlands",
      "Staffordshire": "midlands",
      "Warwickshire": "midlands",
      "West Midlands": "midlands",
      "Worcestershire": "midlands",
      "Derby": "midlands",
      "Leicester": "midlands",
      "North Northamptonshire": "midlands",
      "Stoke-on-Trent": "midlands",
      "Telford and Wrekin": "midlands",
      "West Northamptonshire": "midlands",
      "City of London": "london",
      "Greater London": "london",
      "County Durham": "north_east",
      "Northumberland": "north_east",
      "Tyne and Wear": "north_east",
      "North of Tyne": "north_east",
      "Newcastle upon Tyne": "north_east",
      "North Tyneside": "north_east",
      "Gateshead": "north_east",
      "North East": "north_east",
      "South Tyneside": "north_east",
      "Sunderland": "north_east",
      "Darlington": "north_east",
      "Tees Valley": "north_east",
      "Hartlepool": "north_east",
      "Stockton-on-Tees": "north_east",
      "Redcar and Cleveland": "north_east",
      "Middlesbrough": "north_east",
      "Cheshire": "north_west",
      "Cumbria": "north_west",
      "Greater Manchester": "north_west",
      "Lancashire": "north_west",
      "Merseyside": "north_west",
      "Cheshire East": "north_west",
      "Cheshire West and Chester": "north_west",
      "Halton": "north_west",
      "Warrington": "north_west",
      "Blackpool": "north_west",
      "Blackburn with Darwen": "north_west",
      "Cumberland": "north_west",
      "Westmorland and Furness": "north_west",
      "Berkshire": "south_east",
      "Buckinghamshire": "south_east",
      "East Sussex": "south_east",
      "Hampshire": "south_east",
      "Isle of Wight": "south_east",
      "Kent": "south_east",
      "Oxfordshire": "south_east",
      "Surrey": "south_east",
      "West Sussex": "south_east",
      "Southampton": "south_east",
      "Portsmouth": "south_east",
      "Milton Keynes": "south_east",
      "Brighton and Hove": "south_east",
      "Medway": "south_east",
      "Bracknell Forest": "south_east",
      "Reading": "south_east",
      "Slough": "south_east",
      "West Berkshire": "south_east",
      "Windsor and Maidenhead": "south_east",
      "Wokingham": "south_east",
      "Bristol": "south_west",
      "Cornwall": "south_west",
      "Devon": "south_west",
      "Dorset": "south_west",
      "Gloucestershire": "south_west",
      "Somerset": "south_west",
      "Wiltshire": "south_west",
      "Bath and North East Somerset": "south_west",
      "Bristol City": "south_west",
      "North Somerset": "south_west",
      "South Gloucestershire": "south_west",
      "Swindon": "south_west",
      "Bournemouth, Christchurch and Poole": "south_west",
      "Torbay": "south_west",
      "Plymouth": "south_west",
      "Isles of Scilly": "south_west",
      "East Riding of Yorkshire": "yorkshire_and_the_humber",
      "North Yorkshire": "yorkshire_and_the_humber",
      "South Yorkshire": "yorkshire_and_the_humber",
      "West Yorkshire": "yorkshire_and_the_humber",
      "Kingston upon Hull": "yorkshire_and_the_humber",
      "York": "yorkshire_and_the_humber",
      "Barnsley, Doncaster and Rotherham": "yorkshire_and_the_humber",
      "Sheffield": "yorkshire_and_the_humber",
      "Bradford": "yorkshire_and_the_humber",
      "Leeds": "yorkshire_and_the_humber",
      "Calderdale and Kirklees": "yorkshire_and_the_humber",
      "Wakefield": "yorkshire_and_the_humber",
      "North East Lincolnshire": "yorkshire_and_the_humber",
      "North Lincolnshire": "yorkshire_and_the_humber",
    }
  end

  def departments
    t(departments_raw, scope: 'defines.departments')
  end

  def departments_for_select
    departments.zip(departments_raw)
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

  def all_roles_raw
    ["caster", "coach", "community_editor", "content_creator", "designer", "forum_moderator", "news_editor", "photographer", "seller", "streamer", "team_captain", "tournament_organizer"]
  end

  def all_role_colors
    {
      "caster": "#C93C20",
      "coach": "#3F888F",
      "community_editor": "#05D2F3",
      "content_creator": "#826C34",
      "designer": "#308446",
      "forum_moderator": "#0A0A0A",
      "news_editor": "#F22303",
      "photographer": "#AB3F5D",
      "seller": "#9400D3",
      "streamer": "#79D220",
      "team_captain": "#F4A900",
      "tournament_organizer": "#5071B6",
      "admin": "#FAD201",
      "player": "#007BFF",
    }
  end

  def role_color(role)
    all_role_colors[role.to_sym]
  end

  def roles_raw_from(country_code)
    if country_code == 'ch'
      ["caster", "coach", "content_creator", "designer", "news_editor", "photographer", "player", "seller", "streamer", "team_captain", "tournament_organizer"]
    elsif country_code == 'de'
      ["caster", "coach", "content_creator", "designer", "photographer", "player", "seller", "streamer", "team_captain", "tournament_organizer"] # "forum_moderator",
    elsif country_code == 'fr'
      ["caster", "coach", "community_editor", "content_creator", "designer", "news_editor", "photographer", "player", "seller", "streamer", "team_captain", "tournament_organizer"] # "forum_moderator",
    elsif country_code == 'lu'
      ["caster", "coach", "content_creator", "designer", "photographer", "player", "seller", "streamer", "team_captain", "tournament_organizer"]
    elsif country_code == 'it'
      ["caster", "coach", "community_editor", "content_creator", "designer", "photographer", "player", "seller", "streamer", "team_captain", "tournament_organizer"] # "forum_moderator",
    elsif country_code == 'uk'
      ["caster", "coach", "community_editor", "content_creator", "designer", "news_editor", "photographer", "player", "seller", "streamer", "team_captain", "tournament_organizer"]
    elsif country_code == 'pt'
      ["caster", "coach", "content_creator", "designer", "photographer", "player", "seller", "streamer", "team_captain", "tournament_organizer"] # "community_editor", "forum_moderator",
    elsif country_code == 'is'
      ["caster", "coach", "content_creator", "designer", "news_editor", "photographer", "player", "seller", "streamer", "team_captain", "tournament_organizer"]
    end
  end

  def roles_from(country_code)
    t(roles_raw_from(country_code), scope: 'defines.roles')
  end

  def roles_for_select_from(country_code)
    roles_from(country_code).zip(roles_raw_from(country_code))
  end

  def currency_for_select
    Currency::hash.map{ |k, v| [v, k.to_s] }
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

  def top_players_s1_19_ch
    ['Destany', 'DeepFreeze', 'Smuff', 'Severe Calamari', 'Benji', 'Crash', 'Kepler', 'CrzyShroom', 'Sylph', 'Olivia', 'Ryuji', 'Zudenka', 'SickBoy', 'Phonky', 'Radiance', 'Godoh', 'Jesuischoq', 'ItseMePG', 'TunaLink', 'Acsor', 'Rampage', 'N3rthus', 'TheBlerton', 'Fr0zen', 'Karpador64']
  end

  def top_players_s2_19_ch
    ['Destany', 'Karpador64', 'Crash', 'Phonky', 'DeepFreeze', 'Olivia', 'Kepler', 'SickBoy', 'Jaka', 'ItseMePG', 'Benji', 'Purist', 'Acsor', 'Rampage', 'Yannwatts']
  end

  def top_players_s12_21_ch
    ['Jaka', 'Destany', 'Crash', 'DeepFreeze', 'Kimbo', 'Phonky', 'Deox6', 'Rohan Doge', 'Karpador64', 'Kepler']
  end

  def top_players_s1_22_ch
    ['Destany', 'Jaka', 'Karpador64', 'Deox6', 'Crash', 'Rohan Doge', 'Kimbo', 'Kepler', 'Phonky', 'mistic', 'Byron', 'SickBoy', 'jodel', 'gaya', 'Fr0zen']
  end

  def top_players_s2_22_ch
    ['Destany', 'Jaka', 'Deox6', 'SickBoy', 'Karpador64', 'DeepFreeze', 'Crow', 'PATOO', 'Artyst', 'Byron', 'Kimbo', 'ItseMePG', 'Crash', 'Fr0zen', 'gaya', 'Kepler']
  end

  def top_players_s1_23_ch
    ['Jaka', 'DeepFreeze', 'Deox6', 'SickBoy', 'Destany', 'Byron', 'PATOO', 'Pege', 'gaya', 'Crow', 'Kimbo', 'Phonky', 'Rohan Doge', 'Artyst', 'Fr0zen']
  end

  def top_players_s2_23_ch
    ['Deox6', 'Jaka', 'SickBoy', 'PATOO', 'Kepler', 'Rohan Doge', 'Destany', 'Kimbo', 'DeepFreeze', 'Byron', 'Pege', 'Karpador64', 'Crow', 'Ice-Walker', 'Acsor', 'Crash', 'Phonky', 'Yuno']
  end

  def top_players_s2_23_is
    ['Mapelgold', 'Airli', 'Solar', 'Mr NoMad', 'Egiru', 'Dr BustDown', 'Seether', 'Juce Kid', 'Brake', 'Jópie Trópí', 'Violet', 'Vitleysingur10', 'Eggy']
  end

  def top_players_s1_24_ch
    ['Deox6', 'Jaka', 'DeepFreeze', 'Destany', 'Kepler', 'SickBoy', 'Karpador64', 'Kimbo', 'PATOO', 'Pege', 'Ice-Walker', 'Yuno', 'Zeno', 'SIG', 'Phonky']
  end

end
