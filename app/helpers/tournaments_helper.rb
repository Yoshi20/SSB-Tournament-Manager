module TournamentsHelper

  def active_tournaments_2019
    Tournament.where('active = ? AND date > ? AND date < ?', true, Time.local(2019,1,1), Time.local(2019,12,31,23,59,59))
  end

  def registration_deadline(date)
    date-16*3600
  end

  def max_needed_game_stations_per_tournament(seats)
    seats/4
  end

  def points_repartition_table(rank)
      if rank == 1 then 300
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
