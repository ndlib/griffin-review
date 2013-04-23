class ReservesApp

  def initialize(current_user, semester)
    @user = current_user
  end


  def all_semesters
    Semester.cronologial
  end


  def current_semester
    Semester.current.first
  end


  def copy_course_listing(from_course_id, to_course_id)
    from_course = self.course(from_course_id)
    to_course = self.course(to_course_id)

    CopyCourseListings.new(from_course, to_course)
  end


  def course(course_id)
    if course_id.to_s != "1"
      return nil
    end

    Course.test_data(@user)
  end


  def courses_with_reserves()
    [
      Course.test_data(@user),
      Course.test_data(@user, "Course 2")
    ]
  end


  def courses_without_reserves()
    [
      Course.test_data(@user, "Course 3"),
      Course.test_data(@user, "Course 4")
    ]
  end
end
