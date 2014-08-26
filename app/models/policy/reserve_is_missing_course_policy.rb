class ReserveIsMissingCoursePolicy

  attr_reader :reserve

  def self.call(reserve)
    new(reserve).missing_course?
  end


  def initialize(reserve)
    @reserve = reserve
  end


  def missing_course?
    reserve.course.is_a?(CourseMock)
  end
end
