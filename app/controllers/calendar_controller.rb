class CalendarController < ApplicationController
  before_action { @section = 'calendar' }

  # GET /calendar
  # GET /calendar.json
  def index
    @full_calendar_events = []
  end

end
