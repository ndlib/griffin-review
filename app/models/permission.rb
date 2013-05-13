class Permission

  def initialize(current_user, semester_code)
    @current_user = current_user
    @semester_code = semester_code
  end


  def current_user_is_administrator?
    false
  end


  def current_user_instructs_course?(course_id)
    !reserve_app.instructed_courses.select { | c | c.id == course_id }.empty?
  end


  def current_user_enrolled_in_course?(course_id)
    !reserve_app.enrolled_courses.select { | c | c.id == course_id }.empty?
  end


  private

    def reserve_app
      @reserve_app ||= UserCourseListing.new(@current_user, @semester_code)
    end

end
