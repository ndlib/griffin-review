# creates new active record semester if found
# in academic calendar
class SemesterBuild
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming
  extend ActiveModel::Callbacks

  def initialize
    @calendar_fetch = SemesterCalendarFetch.new
  end

  def find_next_semester
    next_semester = @calendar_fetch.next_semester
    semester = build_semester(next_semester) unless next_semester == :not_found
    unless semester.blank?
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

end
