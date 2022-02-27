class CalendarController < ApplicationController
  before_action { @section = 'calendar' }

  # GET /calendar
  # GET /calendar.ics
  def index
    respond_to do |format|
      format.html do
        tournaments = Tournament.all_from(session['country_code']).for_calendar.includes(:players)
        @full_calendar_events = Calendar.full_calendar_events(current_user, tournaments)
        @cantons = []
        JSON.parse(@full_calendar_events).each do |t|
          canton = t['className'].split(' ')[-1]
          @cantons << canton if ApplicationController.helpers.cantons_raw.include?(canton)
        end
        @cantons = @cantons.uniq
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
        tournaments = Tournament.all_from(session['country_code']).for_calendar.includes(:players)
        @full_calendar_events = Calendar.full_calendar_events(current_user, tournaments)
        @cantons = []
        JSON.parse(@full_calendar_events).each do |t|
          canton = t['className'].split(' ')[-1]
          @cantons << canton if ApplicationController.helpers.cantons_raw.include?(canton)
        end
        @cantons = @cantons.uniq
        render "show", layout: "for_iframe"
      end
    end
  end

end
