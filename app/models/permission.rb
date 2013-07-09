class Permission

  def initialize(current_user)
    @current_user = current_user
  end


  def current_user_is_administrator?
    ['rfox2', 'jhartzle', 'fboze'].include?(@current_user.username)
  end


  def current_user_instructs_course?(course)
    UserRoleInCoursePolicy.new(course, @current_user).user_instructs_course? || current_user_is_administrator?
  end


  def current_user_enrolled_in_course?(course)
    course_in_current_semester?(course) && UserRoleInCoursePolicy.new(course, @current_user).user_enrolled_in_course?
  end


  private

    def course_in_current_semester?(course)
      course.semester.current?
    end

end
