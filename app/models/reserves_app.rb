class ReservesApp
  attr_accessor :semester

  def initialize(current_user, semester_id = false)
    @user = current_user

    if semester_id
      self.semester = Semester.find(semester_id)
    else
      self.semester = self.current_semester
    end
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

    CopyReserves.new(from_course, to_course)
  end


  def course(course_id)
    if course_id.to_s != "1"
      return nil
    end

    Course.test_data(@user)
  end


  def courses_with_reserves()
    if self.semester.code.include?('fall')
      [
        Course.test_data(@user, 'Course Fall')
      ]
    else
      [
        Course.test_data(@user),
        Course.test_data(@user, "Course 2")
      ]
    end
  end


  def courses_without_reserves()
    if self.semester.code.include?('fall')
      [
        Course.test_data(@user, 'Course 6')
      ]
    else
      [
        Course.test_data(@user, "Course 3"),
        Course.test_data(@user, "Course 4")
      ]
    end
  end
end
