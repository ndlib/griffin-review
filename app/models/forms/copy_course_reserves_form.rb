class CopyCourseReservesForm

  attr_accessor :from_course, :to_course

  def initialize(from_course, to_course, request_attributes = {})
    @from_course = from_course
    @to_course   = to_course
    @request_attributes = request_attributes
  end


  def from_course_title
    @from_course.title
  end


  def to_course_title
    @to_course.title
  end


  def copied_items
    @copied_items ||= []
  end


  def self.current_semester_courses(current_user)
    ucl = UserCourseListing.new(current_user, Semester.current.first.code)
    ucl.instructed_courses
  end


  def self.next_semester_courses(current_user)
    next_semester = Semester.current.first.next
    if next_semester
      ucl = UserCourseListing.new(current_user, next_semester.code)
      ucl.instructed_courses
    else
      []
    end
  end


  def copy_items()
    return [] if !@request_attributes[:reserve_ids]

    reserve_search = ReserveSearch.new

    @copied_items = []
    @request_attributes[:reserve_ids].each do | rid |
      reserve = reserve_search.get(rid, @from_course)
      if reserve
        @copied_items << CopyReserve.new(@to_course, reserve).copy
      end
    end

    return @copied_items
  end
end
