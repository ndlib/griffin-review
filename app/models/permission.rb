class Permission

  def initialize(current_user)
    @current_user = current_user
  end


  def current_user_is_administrator?
    true
  end


  def current_user_instructs_course?(course)
    course.instructor_netids.include?(@current_user.username)
  end


  def current_user_enrolled_in_course?(course)
    course.enrollment_netids.include?(@current_user.username)
  end


  private

    def course_listing(semester_code)
      @course_listing ||= {}
      @course_listing[semester_code] ||= UserCourseListing.new(@current_user, semester_code)
    end

end
