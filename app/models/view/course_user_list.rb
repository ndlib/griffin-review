
class CourseUserList
  include GetCourse
  include ModelErrorTrapping

  attr_accessor :course

  def initialize(current_user, params)
    @course = get_course(params[:course_id])
  end


  def enrolled_students
    @course.enrollments
  end


  def instructors
    @course.instructors
  end


  def users
    enrolled_students + instructors
  end


end
