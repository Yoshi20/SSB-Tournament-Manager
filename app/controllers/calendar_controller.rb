class CalendarController < ApplicationController
  before_action { @section = 'calendar' }

  # GET /calendar
  # GET /calendar.ics
  def index
    respond_to do |format|
      format.html do
        @full_calendar_events = Calendar.full_calendar_events(current_user, calendar_tournaments.includes(:players))
        @regions = []
        JSON.parse(@full_calendar_events).each do |t|
          region = t['className'].split(' ')[-1]
          @regions << region if ApplicationController.helpers.regions_raw_from(session['country_code']).include?(region)
        end
        @regions = @regions.uniq
      end
      format.ics do
        send_data Calendar.ical_events(calendar_tournaments), filename: 'tournaments.ics', disposition: 'inline', type: 'text/Calendar'
      end
    end
  end

  # GET /calendar_for_iframe
  # GET /calendar_for_iframe.ics
  def show
    respond_to do |format|
      format.html do
        @full_calendar_events = Calendar.full_calendar_events(current_user, calendar_tournaments.includes(:players))
        @regions = []
        JSON.parse(@full_calendar_events).each do |t|
          region = t['className'].split(' ')[-1]
          @regions << region if ApplicationController.helpers.regions_raw_from(session['country_code']).include?(region)
        end
        @regions = @regions.uniq
        render "show", layout: "for_iframe"
      end
    end
  end

  private

  def calendar_tournaments
    tournaments = Tournament.all_from(session['country_code']).for_calendar
    if params[:filter].present? and params[:filter] != 'all'
      if helpers.regions_raw_from(session['country_code']).include?(params[:filter])
        tournaments = tournaments.where(region: params[:filter])
      end
    end
    return tournaments
  end

end
