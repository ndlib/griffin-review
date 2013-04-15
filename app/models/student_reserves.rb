class StudentReserves

  def initialize(current_user, semester)
    @user = current_user
  end


  def course(course_id)
    if course_id != "1"
      return nil
    end

    Course.new(title: "Course 1")
  end


  def courses_with_reserves()
    [
      Course.new(title: "Course 1"),
      Course.new(title: "Course 2")
    ]
  end


  def courses_without_reserves()
    [
      Course.new(title: "Course 3"),
      Course.new(title: "Course 4")
    ]
  end
end
