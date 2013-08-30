class CourseHeader

  attr_accessor :course, :course_section

  delegate :title, to: :course_section

  def initialize(course, current_user)
    @course = course
    @current_user = current_user
    @course_section = FindUserSectionInCourse.new(@course, @current_user).find

    if @course_section.nil?
      raise "unable to find course section for user."
    end
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
