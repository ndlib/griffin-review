
class ReservesAdminApp

  def initialize(current_user, semester_code = false)
    if semester_code
      @semester = Semester.semester_for_code(semester_code)
    else
      @semester = Semester.current.first
    end

    @current_user = current_user
  end


  def in_complete_reserves
    reserve_search.new_and_inprocess_reserves_for_semester(@semester)
  end


  def completed_reserves
    reserve_search.available_reserves_for_semester(@semester)
  end


  def all_reserves
    reserve_search.all_reserves_for_semester(@semester)
  end


  def reserve(id)
    AdminReserve.new(reserve_search.get(id, self))
  end


  def netid_instructed_courses(netid, semester)
    ca = CourseSearch.new
    ca.instructed_courses(netid, semester)
  end


  def all_courses

  end


  def course(id, netid)
    course_search = CourseSearch.new
    course_search.get(netid, id)
  end


  private


  def reserve_search
      @reserve_search ||= ReserveSearch.new
    end

end
