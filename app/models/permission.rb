class Permission

  def initialize(current_user)
    @current_user = current_user
  end


  def current_user_is_administrator?
    true
  end


  def current_user_instructs_course?(course)
    !course_listing(course.term).instructed_courses.select { | c | c.id == course.id }.empty?
  end


  def current_user_enrolled_in_course?(course)
    !course_listing(course.term).enrolled_courses.select { | c | c.id == course.id }.empty?
  end


  private

    def course_listing(semester_code)
      @course_listing ||= {}
      @course_listing[semester_code] ||= UserCourseListing.new(@current_user, semester_code)
    end

end
