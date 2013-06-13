class UserCourseListing
  include ModelErrorTrapping

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


  def course(course_id)
    c = course_search.get(course_id)
    policy = UserRoleInCoursePolicy.new(c, @user)

    return nil if c.nil? || (!policy.user_enrolled_in_course? && !policy.user_instructs_course?)

    c
  end


  def has_enrolled_courses?
    !courses_with_reserves().empty?
  end


  def has_instructed_courses?
    !course_search.instructed_courses(@user.username, @semester.code).empty?
  end


  def enrolled_courses
    course_search.enrolled_courses(@user.username, current_semester.code)
  end


  def courses_with_reserves()
    #res = []
    #i = 0
    course_search.enrolled_courses(@user.username, current_semester.code).reject { | c | c.published_reserves.empty? }
    # do | c |
    #  if i % 2 == 1
    #    res << c
    #  end
    #  i += 1
    #end
    #res
  end


  def instructed_courses_with_reserves()
    #res = []
    #i = 0
    course_search.instructed_courses(@user.username, @semester.code).reject { | c | c.reserves.empty? }
    # do | c |
    #  if i % 2 == 1
    #    res << c
    #  end
    #  i += 1
    #end
    #res
  end


  def instructed_courses
    course_search.instructed_courses(@user.username, @semester.code)
  end


  private

    def course_search
      @course_search ||= CourseSearch.new
    end

end
