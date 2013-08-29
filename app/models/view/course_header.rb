class CourseHeader

  attr_accessor :course, :course_section

  delegate :title, to: :course_section

  def initialize(course, current_user)
    @course = course
    @course_section = course.get_section_for_user(current_user)
  end


  def semester_name
    @course.semester.full_name
  end


  def sections
    @course.section_numbers.join(", ")
  end


  def instructor_name
    @course.primary_instructor.display_name
  end
end
