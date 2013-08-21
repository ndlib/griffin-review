class CourseHeader

  attr_accessor :course

  delegate :title, to: :course

  def initialize(course)
    @course = course
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
