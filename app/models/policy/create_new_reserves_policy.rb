class CreateNewReservesPolicy

  def initialize(course)
    @course = course
  end


  def can_create_new_reserves?
    @course.semester.current? || @course.semester.future?
  end

end
