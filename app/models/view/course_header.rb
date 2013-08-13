class CourseHeader

  attr_accessor :course

  delegate :title, :instructor_name, to: :course

  def initialize(course)
    @course = course
  end


  def semester_name
    @course.semester.full_name
  end


  def sections
    @course.section_numbers.join(", ")
  end

end
