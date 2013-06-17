
class UserArchiveCourseListing

  def initialize(current_user)
    @user = current_user
  end


  def previous_semesters

  end


  def semester_instructed_courses_with_reserves(semester)
    course_search.instructed_courses(@user.username, semester.code).reject { | c | c.reserves.empty? }
  end


  private

    def course_search
      @course_search ||= CourseSearch.new
    end


end
