module TournamentsHelper
  def registration_deadline(date)
    date-16*3600
  end
end
