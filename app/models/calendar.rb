require 'icalendar/tzinfo'

class Calendar
  class << self

    def full_calendar_events(current_user)
      tournaments = Tournament.for_calendar
      tournaments.map do |tournament|
        full_calendar_event(tournament, current_user)
      end.to_json
    end

    def full_calendar_event(tournament, current_user)
      # TODO change date to from and to?
      isFullDayEvent = (tournament.date.hour == 0 and tournament.date.min == 0)
      {
        title:     tournament.name.to_s,
        start:     tournament.date.try(:iso8601),
        end:       isFullDayEvent ? nil : (tournament.date + 4.hours),
        allDay:    isFullDayEvent,
        editable:  false,
        className: 'calendar-tournament',
        color:     get_event_color(tournament, current_user),
        url:       tournament.external_registration_link || "/tournaments/#{tournament.id}",
        status:    tournament.cancelled? ? 'CANCELLED' : nil,
      }
    end

    def get_event_color(tournament, current_user)
      if tournament.date + 4.hours < DateTime.now and tournament.subtype != 'external'
        # past tournament
        'lightgray'
      elsif tournament.subtype == 'external'
        if tournament.date + 24.hours < DateTime.now
          'lightgray' # past
        else
          # external tournament
          'cornflowerblue'
        end
      elsif tournament.cancelled?
        # cancelled
        'lightsalmon'
      elsif tournament.registration_deadline.present? and tournament.registration_deadline < DateTime.now
        # registration deadline exceeded? -> ongoing
        'darkorange'
      elsif tournament.subtype == 'internal'
        # internal tournament
        if current_user.present? and tournament.players.include?(current_user.player)
          # joined
          'mediumorchid'
        else
          'orchid'
        end
      else
        # weekly
        if current_user.present? and tournament.players.include?(current_user.player)
          # joined
          '#07a468' # green
        else
          '#61bf9b' # light green
        end
      end
    end

    def ical_events
      tournaments = Tournament.for_calendar
      ical_events_internal(tournaments)
    end

    def ical_event(id)
      tournaments = [Tournament.find(id)]
      ical_events_internal(tournaments)
    end

    private

    def ical_events_internal(tournaments)
      calendar = Icalendar::Calendar.new
      tzid     = 'CET'
      tz       = TZInfo::Timezone.get tzid
      timezone = tz.ical_timezone Time.current
      calendar.add_timezone timezone
      tournaments.each do |tournament|
        ical_event_internal(calendar, tournament, tzid)
      end
      calendar.to_ical
    end

    def ical_event_internal(calendar, tournament, tzid)
      calendar.event do |event|
        end_time = tournament.date + 4.hours
        if false
          # whole-day tournament structure
          event.dtstart = ical_date(tournament.date.to_date)
          event.dtend   = ical_date(end_time.to_date)
          event.dtstart.ical_param 'VALUE', 'DATE'
          event.dtend.ical_param 'VALUE', 'DATE'
        else
          event.dtstart = ical_datetime(tournament.date, tzid)
          event.dtend   = ical_datetime(end_time, tzid)
        end
        event.summary     = tournament.name.to_s.strip
        event.description = tournament.description.to_s.strip
        event.location    = tournament.location.to_s.strip
      end
    end

    def ical_date(date)
      Icalendar::Values::Date.new(date)
    end

    def ical_datetime(time, tzid)
      Icalendar::Values::DateTime.new(time, tzid: tzid)
    end

  end
end
