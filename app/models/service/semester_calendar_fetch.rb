# fetches the latest academic calendar in
# order to create up to date semester instances
class SemesterCalendarFetch
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming
  extend ActiveModel::Callbacks
  
  def initialize
    rails_config = Rails.configuration
    @semester_start_date = 'not_found'
    @semester_end_date = 'not_found'
    @rest_connection = ExternalRest.new(base_url: rails_config.nd_calendar, path: rails_config.nd_calendar_path)
    parse_calendar
  end

  def next_semester
    find_and_build_next_semester
  end

  private

  def rest_connection
    @rest_connection
  end

  def calendar_events
    @calendar_events
  end

  def fetch_calendar
    @rest_connection.transact
  end

  def parse_calendar
    @calendar_events = fetch_calendar.bedework.events.event
    @calendar_first_day = Date.parse(calendar_events.first.start.unformatted)
    @calendar_last_day = Date.parse(calendar_events.last.start.unformatted)
  end

  def calendar_first_day
    @calendar_first_day
  end

  def calendar_last_day
    @calendar_last_day
  end

  def find_and_build_next_semester
    next_semester = :not_found
    calendar_events.map { |event| 
      event_desc = event.description
      event_summ = event.summary
      event_start = event.start.unformatted
      assign_date(event_start, event_desc, event_summ) if semester_event?(event) }
    if semester_dates_found?
      next_semester = SemesterDateNormalizer.new(begin_date: @semester_start_date, end_date: @semester_end_date) 
    end
    next_semester
  end

  def assign_date(event_start, event_description, event_summary)
    if classes_begin_event?(event_description, event_summary)
      @semester_start_date = event_start
    elsif classes_end_event?(event_description)
      @semester_end_date = event_start
    end
  end

  def semester_dates_found?
    @semester_start_date != 'not_found' && @semester_end_date != 'not_found'
  end

  def semester_event?(event)
    event_description = event.description
    event_summary = event.summary
     classes_begin_event?(event_description, event_summary) || classes_end_event?(event_description)
  end

  def classes_begin_event?(event_description, event_summary)
    event_description =~ /classes begin/i ||
    event_summary =~ /classes begin/i ||
    event_description =~ /first day of classes/i ||
    event_summary =~ /first day of classes/i
  end

  def classes_end_event?(event_description)
    event_description =~ /last class day/i
  end

end
