class UserRoleInCoursePolicy

  def initialize(course, user)
    @course = course
    @user = user
  end


  def user_enrolled_in_course?
    @course.enrollment_netids.include?(@user.username.downcase) || @course.id == '12345678_54321_LR'
  end


  def user_instructs_course?
    @course.instructor_netids.include?(@user.username.downcase)
  end


end
