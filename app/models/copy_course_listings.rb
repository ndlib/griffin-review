class CopyCourseListings
  attr_accessor :from_course, :to_course

  def initialize(from_course, to_course)
    @from_course = from_course
    @to_course = to_course
  end


  def from_course_title
    @from_course.title
  end


  def to_course_title
    @to_course.title
  end

  def copy_items(item_ids)

    return true
  end
end
