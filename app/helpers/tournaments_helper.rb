module TournamentsHelper

  def tournament_cities
    ['Baden', 'Basel', 'Bern', 'Burgdorf', 'Geneva', 'Solothurn', 'Trimbach', 'Zurich']
  end

  def tournament_majors
    ["Colosseum Basel", "Fantasy Basel", "Japan Impact", "PK Bern", "Polymanga",
      "Saint Smash", "SwissGeek", "TheReset", "UltiBaits", "UltiMelt",
      "UltiMon", "University of Smash"]
    # Unspecific tournaments:
    # Smash Temple
    # Smash Ultimate Release Tournament Card Tower Solothurn
    # Qwertz Ultimate Tournament #1
    # Hardread 10.1.
    # random
    # seed
    # Casino - Let&#039;s Play #1
    # Smile & Wave(s) - A SILENTGAMING Smas
    # Super Smash Bros Ultimate - Tournoi Mix-Image/jeuxvideo.ch du 23 mars 2019
    # Carrefour Sud Monthly
    # Smash at Frag #1
    # Smash the Cake
    # Smash at PolyLan
    # Chablais LAN #2
    # Super Smash Saga - Calm before the Storm
  end

  def valid_challonge_url(str)
    str.downcase.gsub(/[^0-9A-Za-z\s]/, '').strip.gsub(' ', '_').gsub('__', '_').gsub('__', '_')
  end

  def valid_challonge_description(str)
    strArray = str.split('<script>')
    str = strArray[0]
    if strArray.size >= 2
      (strArray.size - 1).times do |n|
        strArray2 = strArray[n+1].split('</script>')
        str += strArray2[1] if strArray2.size >= 2
      end
    end
    return str
  end

  def points_repartition_table(rank)
      if rank.nil? or rank == 0 then 0
      elsif rank == 1 then 300
      elsif rank == 2 then 250
      elsif rank == 3 then 200
      elsif rank == 4 then 150
      elsif rank <= 6 then 100
      elsif rank <= 8 then 75
      elsif rank <= 12 then 50
      elsif rank <= 16 then 25
      elsif rank <= 24 then 15
      elsif rank <= 32 then 10
      else 5
      end
  end

end
