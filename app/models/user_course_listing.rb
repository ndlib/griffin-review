class UserCourseListing
  attr_accessor :semester

  def initialize(current_user, semester_code = false)
    @user = current_user

    if semester_code
      @semester = Semester.semester_for_code(semester_code)
    else
      @semester = self.current_semester
    end
  end


  def all_semesters
    Semester.cronologial
  end


  def current_semester
    Semester.current.first
  end


  def copy_course_listing(from_course_id, to_course_id)
    from_course = self.course(from_course_id)
    to_course = self.course(to_course_id)

    CopyReserves.new(from_course, to_course)
  end


  def course(course_id)
    course_api.get(@user.username, course_id)
  end


  def has_enrolled_courses?
    !course_api.enrolled_courses(@user.username, current_semester.code).empty?
  end


  def has_instructed_courses?
    !course_api.instructed_courses(@user.username, @semester.code).empty?
  end


  def enrolled_courses
    course_api.enrolled_courses(@user.username, current_semester.code)
  end


  def courses_with_reserves()
    res = []
    i = 0
    course_api.enrolled_courses(@user.username, current_semester.code).each do | c |
      if i % 2 == 1
        res << c
      end
      i += 1
    end

    res
  end


  def instructed_courses_with_reserves()
    res = []
    i = 0
    course_api.instructed_courses(@user.username, @semester.code).each do | c |
      if i % 2 == 1
        res << c
      end
      i += 1
    end

    res
  end


  def instructed_courses
    course_api.instructed_courses(@user.username, @semester.code)
  end


  private

    def course_api
      @course_api ||= CourseApi.new
    end

end
