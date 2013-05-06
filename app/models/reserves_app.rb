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


  def has_enrolled_courses?
    !@enrolled_courses_with_reserves.empty? || !@enrolled_courses_without_reserves.empty?
  end


  def has_instructed_courses?
    !@instructed_courses_with_reserves.empty? || !@instructed_courses_without_reserves.empty?
  end


  def courses_with_reserves()
    if !@enrolled_courses_with_reserves
      load_user_courses
    end

    return @enrolled_courses_with_reserves
  end


  def courses_without_reserves()
    if !@enrolled_courses_without_reserves
      load_user_courses
    end

    return @enrolled_courses_without_reserves
  end


  def instructed_courses_with_reserves()
    if !@instructed_courses_with_reserves
      load_user_courses
    end

    return @instructed_courses_with_reserves
  end


  def instructed_courses_without_reserves()
    if !@instructed_courses_without_reserves
      load_user_courses
    end

    return @instructed_courses_without_reserves
  end


  def self.reserve_test_data
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

    def load_user_courses
      all_courses = API::Person.courses('jdan', '201210')

      load_enrolled_courses(all_courses['enrolled_courses'])
      load_instructed_courses(all_courses['instructed_courses'])
    end


    def load_enrolled_courses(enrolled_courses)
      @enrolled_courses_with_reserves = []
      @enrolled_courses_without_reserves = []

      i = 1
      enrolled_courses.each do | c |
        c = Course.new(c)
        if i % 2 == 1
          @enrolled_courses_with_reserves << c
        else
          @enrolled_courses_without_reserves << c
        end
        i += 1
      end
    end


    def load_instructed_courses(instructed_courses)
      @instructed_courses_with_reserves = []
      @instructed_courses_without_reserves = []

      i = 1
      instructed_courses.each do | c |
        c = Course.new(c)
        if i % 2 == 1
          @instructed_courses_with_reserves << c
        else
          @instructed_courses_without_reserves << c
        end
        i += 1
      end
    end
end
