class CalendarController < ApplicationController
  before_action { @section = 'calendar' }

  # GET /calendar
  # GET /calendar.ics
  def index
    respond_to do |format|
      format.html do
        @full_calendar_events = Calendar.full_calendar_events(current_user, calendar_tournaments.includes(:players))
        if session['country_code'] == 'ch'
          @cantons = []
          JSON.parse(@full_calendar_events).each do |t|
            canton = t['className'].split(' ')[-1]
            @cantons << canton if ApplicationController.helpers.cantons_raw.include?(canton)
          end
          @cantons = @cantons.uniq
        elsif session['country_code'] == 'de'
          @federal_states = []
          JSON.parse(@full_calendar_events).each do |t|
            federal_state = t['className'].split(' ')[-1]
            @federal_states << federal_state if ApplicationController.helpers.federal_states_raw.include?(federal_state)
          end
          @federal_states = @federal_states.uniq
        elsif session['country_code'] == 'fr'
          @regions = []
          JSON.parse(@full_calendar_events).each do |t|
            region = t['className'].split(' ')[-1]
            @regions << region if ApplicationController.helpers.regions_raw.include?(region)
          end
          @regions = @regions.uniq
        end
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
        if session['country_code'] == 'ch'
          @cantons = []
          JSON.parse(@full_calendar_events).each do |t|
            canton = t['className'].split(' ')[-1]
            @cantons << canton if ApplicationController.helpers.cantons_raw.include?(canton)
          end
          @cantons = @cantons.uniq
        elsif session['country_code'] == 'de'
          @federal_states = []
          JSON.parse(@full_calendar_events).each do |t|
            federal_state = t['className'].split(' ')[-1]
            @federal_states << federal_state if ApplicationController.helpers.federal_states_raw.include?(federal_state)
          end
          @federal_states = @federal_states.uniq
        elsif session['country_code'] == 'fr'
          @regions = []
          JSON.parse(@full_calendar_events).each do |t|
            region = t['className'].split(' ')[-1]
            @regions << region if ApplicationController.helpers.regions_raw.include?(region)
          end
          @regions = @regions.uniq
        end
        render "show", layout: "for_iframe"
      end
    end
  end

  private

  def calendar_tournaments
    tournaments = Tournament.all_from(session['country_code']).for_calendar
    if params[:filter].present? and params[:filter] != 'all'
      if helpers.cantons_raw.include?(params[:filter])
        tournaments = tournaments.where(canton: params[:filter])
      elsif helpers.federal_states_raw.include?(params[:filter].upcase)
        tournaments = tournaments.where(federal_state: params[:filter].upcase)
      elsif helpers.regions_raw.include?(params[:filter])
        tournaments = tournaments.where(region: params[:filter])
      end
    end
    return tournaments
  end

end
