require 'icalendar/tzinfo'

class Calendar
  class << self

    def full_calendar_events
      tournaments = Tournament.where('date > ?', 2.weeks.ago)
      tournaments.map do |tournament|
        full_calendar_event(tournament)
      end.to_json
    end

    def full_calendar_event(tournament)
      # TODO change date to from and to? do we have whole-day events?
      {
        title:     tournament.name.to_s,
        start:     tournament.date.try(:iso8601),
        end:       tournament.date + 4.hours,
        allDay:    false,
        editable:  false,
        className: 'calendar-tournament',
        color:     get_event_color(tournament),
        url:       tournament.external_registration_link || "/tournaments/#{tournament.id}",
      }
    end

    def get_event_color(tournament)
      if tournament.canceled?
        'lightsalmon'
      elsif tournament.external_registration_link.present?
        'cornflowerblue'
      else
        '#61bf9b'
      end
      # 'darkcyan' #dunkles blau/grün
      # 'darkgray'
      # 'darkorchid'
    end

    def ical_events
      tournaments = Tournament.where('date > ?', 2.weeks.ago)
      ical_events_internal(tournaments)
    end

    def ical_event(id)
      tournaments = [Tournament.find(id)]
      ical_events_internal(tournaments)
    end

    private

    def ical_events_internal(tournamente)
      calendar = Icalendar::Calendar.new
      tzid     = 'CET'
      tz       = TZInfo::Timezone.get tzid
      timezone = tz.ical_timezone Time.current
      calendar.add_timezone timezone
      tournamente.each do |tournament|
        ical_event_internal(calendar, tournament, tzid)
      end
      calendar.to_ical
    end

    def ical_event_internal(calendar, tournament, tzid)
      calendar.event do |event|
        end_time = tournament.date + 4.hours
        if false # whole-day tournament structure
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
