class Permission

  def initialize(current_user)
    @current_user = current_user
  end


  def current_user_is_administrator?
    true
  end


  def current_user_instructs_course?(course)
    UserRoleInCoursePolicy.new(course, @current_user).user_instructs_course?
  end


  def current_user_enrolled_in_course?(course)
    UserRoleInCoursePolicy.new(course, @current_user).user_enrolled_in_course?
  end


  private

end
