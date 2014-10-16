# creates new active record semester if found
# in academic calendar
class SemesterBuild
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming
  extend ActiveModel::Callbacks

  def initialize
    @calendar_fetch = SemesterCalendarFetch.new
    @current_semester = Semester.current.first
  end

  def find_next_semester
    next_semester = @calendar_fetch.next_semester
    semester = build_semester(next_semester) unless next_semester == :not_found
    if semester.blank?
      check_for_notification
    else
      semester.save! if semester.valid?
    end
  end

  private

  def build_semester(next_semester)
    Semester.new do |semester|
      semester.code = next_semester.derive_code
      semester.full_name = next_semester.derive_semester_name
      semester.date_begin = next_semester.begin_date
      semester.date_end = next_semester.end_date
    end
  end

  def check_for_notification
    if past_drop_dead_date?
      send_alert_notification
    end
  end

  def past_drop_dead_date?
    if Date.today > drop_dead_date
      true
    end
  end

  def drop_dead_date
    case @current_semester.full_name 
    when /Fall/
      Date.parse('11/15')
    when /Spring/
      Date.parse('04/15')
    when /Summer/
      Date.parse('8/1')
    end
  end

  def send_alert_notification
    SemesterMailer.semester_notify.deliver
    :alert_notification_sent
  end

end
