class ReservesApp
  attr_accessor :semester

  def initialize(current_user, semester_id = false)
    @user = current_user

    if semester_id
      @semester = Semester.find(semester_id)
    else
      @semester = self.current_semester
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


  def current_user_instructs_course?(course_id)
    !instructed_courses.select { | c | c.id == course_id }.empty?
  end


  def current_user_enrolled_in_course?(course_id)
    !enrolled_courses.select { | c | c.id == course_id }.empty?
  end


  def course(course_id)
    course_api.get(course_id, @user.username, @semester.code)
  end


  def has_enrolled_courses?
    !course_api.enrolled_courses(@user.username, current_semester.code).empty?
  end


  def has_instructed_courses?
    !course_api.instructed_courses(@user.username, @semester.code).empty?
  end


  def enrolled_courses
    course_api.enrolled_courses(@user.username, current_semester.code)
  end


  def courses_with_reserves()
    res = []
    i = 0
    course_api.enrolled_courses(@user.username, current_semester.code).each do | c |
      if i % 2 == 1
        res << c
      end
      i += 1
    end

    res
  end


  def instructed_courses_with_reserves()
    res = []
    i = 0
    course_api.instructed_courses(@user.username, @semester.code).each do | c |
      if i % 2 == 1
        res << c
      end
      i += 1
    end

    res
  end


  def instructed_courses
    course_api.instructed_courses(@user.username, @semester.code)
  end


  def self.reserve_test_data(course)
    Reserve

    [
      BookReserve.test_request(1),
      BookChapterReserve.test_request(2),
      JournalReserve.test_file_request(3),
      JournalReserve.test_url_request(4),
      VideoReserve.test_request(5),
      AudioReserve.test_request(6),
      BookReserve.new_request(7),
      BookReserve.awaiting_request(8),
      BookChapterReserve.new_request(9),
      BookChapterReserve.awaiting_request(10),
      VideoReserve.awaiting_request(11),
      VideoReserve.new_request(12),
    ]
  end

  private

    def course_api
      @course_api ||= CourseApi.new
    end

end
