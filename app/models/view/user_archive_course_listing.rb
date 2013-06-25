
class UserArchiveCourseListing

  def initialize(current_user)
    @user = current_user
  end


  def has_any_archived_instructed_courses?
    archived_semesters.each do | s |
      return true if semester_has_courses?(s)
    end

    return false
  end


  def archived_semesters
    Semester.semesters_before_semester(Semester.current.first)
  end


  def semester_has_courses?(semester)
    (semester_instructed_courses_with_reserves(semester).size > 0)
  end


  def semester_instructed_courses_with_reserves(semester)
    @semester_courses ||= {}
    @semester_courses[semester.code] ||= course_search.instructed_courses(@user.username, semester.code).reject { | c | c.reserves.empty? }
  end


  private

    def course_search
      @course_search ||= CourseSearch.new
    end


end
