require 'icalendar/tzinfo'

class Calendar
  class << self

    def full_calendar_events(current_user, tournaments)
      tournaments.map do |tournament|
        full_calendar_event(tournament, current_user)
      end.to_json
    end

    def full_calendar_event(tournament, current_user)
      # TODO change date to from and to?
      isFullDayEvent = (tournament.date.hour == 0 and tournament.date.min == 0)
      icon = tournament.region
      {
        title:     tournament.name.to_s,
        start:     tournament.date.try(:iso8601),
        end:       isFullDayEvent ? nil : (tournament.weekly? ? (tournament.date + 3.hours) : (tournament.date + 6.hours)),
        allDay:    isFullDayEvent,
        editable:  false,
        className: icon.present? ? "calendar-tournament calendar-has-icon-class #{icon}" : "calendar-tournament",
        color:     get_event_color(tournament, current_user),
        url:       tournament.external_registration_link.present? ? tournament.external_registration_link : "/tournaments/#{tournament.id}",
      }
    end

    def get_event_color(tournament, current_user)
      if tournament.started and tournament.finished
        # past tournament
        'lightgray'
      elsif tournament.subtype != 'external' and tournament.date + 6.hours < Time.zone.now
        # past tournament
        'lightgray'
      elsif tournament.subtype == 'external'
        if tournament.date + 24.hours < Time.zone.now
          'lightgray' # past
        else
          # external tournament
          'cornflowerblue'
        end
      elsif tournament.cancelled?
        # cancelled
        'lightsalmon'
      elsif tournament.registration_deadline.present? and tournament.registration_deadline < Time.zone.now
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

    def ical_events(tournaments)
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
      isFullDayEvent = (tournament.date.hour == 0 and tournament.date.min == 0)
      end_time = isFullDayEvent ? (tournament.date + 1.day) : (tournament.weekly? ? (tournament.date + 3.hours) : (tournament.date + 6.hours))
      calendar.event do |event|
        if isFullDayEvent
          # whole-day tournament structure
          event.dtstart = ical_date(tournament.date.to_date)
          event.dtstart.ical_param 'VALUE', 'DATE'
          event.dtend   = ical_date(end_time.to_date)
          event.dtend.ical_param 'VALUE', 'DATE'
        else
          event.dtstart = ical_datetime(tournament.date, tzid)
          event.dtend   = ical_datetime(end_time, tzid)
        end
        event.summary     = tournament.name.to_s.strip
        event.description = tournament.description.to_s.strip
        event.location    = tournament.location.to_s.strip
        event.url         = tournament.external_registration_link.present? ? tournament.external_registration_link : "/tournaments/#{tournament.id}"
        if tournament.cancelled?
          event.status = 'CANCELLED'
        end
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
