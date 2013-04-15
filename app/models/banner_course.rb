class BannerCourse

  def initialize(course_id, semester)
    @course_id = course_id
    @semester = semester
  end

  def title
    "Course 1"
  end


  def instructor
    "Instructor"
  end


  def students
    []
  end


  def instructors

  end


  def reserves
    TestRequest

    [
      TestRequestPage.new(BookRequest.test_request)
    ]
  end

end
