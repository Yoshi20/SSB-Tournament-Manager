class CalendarController < ApplicationController
  before_action { @section = 'calendar' }

  # GET /calendar
  # GET /calendar.ics
  def index
    respond_to do |format|
      format.html do
        @full_calendar_events = Calendar.full_calendar_events(current_user)
      end
      format.ics do
        send_data Calendar.ical_events, filename: 'tournaments.ics', disposition: 'inline', type: 'text/Calendar'
      end
    end
  end

  # GET /calendar_for_iframe
  # GET /calendar_for_iframe.ics
  def show
    respond_to do |format|
      format.html do
        @full_calendar_events = Calendar.full_calendar_events(current_user)
        render "show", layout: "for_iframe"
      end
    end
  end

end
