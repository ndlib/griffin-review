
class ReservesAdminApp

  def initialize(semester, current_user)
    @semester = semester
    @current_user = current_user
  end


  def in_complete_reserves
    all_reserves.select { | r | r.workflow_state != 'complete' }
  end


  def completed_reserves
    all_reserves.select { | r | r.workflow_state == 'complete' }
  end


  def all_reserves
    Course.reserve_test_data(Course.new).collect { | r | AdminReserve.new(r) }
  end


  def reserve(id)
    AdminReserve.new(Course.reserve_test_data(Course.new)[id.to_i - 1])
  end


  def netid_instructed_courses(netid, semester)
    ca = CourseApi.new
    ca.instructed_courses(netid, semester)
  end


  def all_courses

  end


  def course(id, netid)
    course_api = CourseApi.new
    course_api.get(netid, id)
  end


  private


end
