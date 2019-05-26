module TournamentsHelper

  def min_needed_game_stations_per_tournament(seats)
    if seats.nil? then return 0 end
    min_needed_game_stations = seats/4
    if min_needed_game_stations == 0 then min_needed_game_stations = 1 end
    return min_needed_game_stations
  end

  def valid_challonge_url(str)
    str.downcase.gsub(/[^0-9A-Za-z\s]/, '').strip.gsub(' ', '_').gsub('__', '_').gsub('__', '_')
  end

  def points_repartition_table(rank)
      if rank.nil? then 0
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
