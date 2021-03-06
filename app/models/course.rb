class Course
  attr_accessor :sections, :id, :primary_instructor_hash

  def initialize(id, primary_instructor_hash)
    @id = id
    @primary_instructor_hash = primary_instructor_hash
    @sections ||= []
  end


  def self.factory(id, primary_instructor_hash, mock_flag = nil)
    # because of the complex systems in play we have created a course mock.
    # this is the point it gets loaded from course search.  It is a separate class that duck types course.
    # in the future if a new system of creating courses is generated that does not require a mock like this this
    # should be removed.
    if mock_flag
      CourseMock.new(id, primary_instructor_hash)
    else
      Course.new(id, primary_instructor_hash)
    end
  end


  def title
    @sections.first.title
  end


  def full_title
    @sections.first.full_title
  end


  def add_section(section_json)
    if section_json.present?
      @sections << CourseSection.factory(id, section_json)
    end
  end


  def unique_supersection_ids
    @sections.collect {|s| s.supersection_id }.uniq
  end


  def enrollments
    @enrollments ||= (
      banner_enrollment_netids.collect { | netid | marshal_course_user(netid, 'enrollment', 'banner') } +
      exception_enrollment_netids.collect { | netid | marshal_course_user(netid, 'enrollment', 'exception') }
    )
  end


  def enrollment_netids
    @enrollment_netids ||= (banner_enrollment_netids + exception_enrollment_netids)
  end


  def instructor_netid
    primary_instructor.username
  end


  def primary_instructor
    @primary_instructor ||= marshal_course_user(@primary_instructor_hash['netid'], 'instructor', 'banner')
  end


  def instructors
    @instructors ||= (
      banner_instructor_netids.collect { | netid | marshal_course_user(netid, 'instructor', 'banner') } +
      exception_instructors_netids.collect { | netid | marshal_course_user(netid, 'instructor', 'exception') }
    )
  end


  def instructor_netids
    @instructor_netids ||= banner_instructor_netids + exception_instructors_netids
  end


  def term
    @sections.first.term
  end


  def semester_name
    semester.full_name
  end


  def semester
    @semester ||= Semester.semester_for_code(term)
  end


  def crosslisted_course_number
    "#{crosslisted_course_ids.join(", ")} - #{section_numbers.join(", ")}"
  end


  def section_numbers
    @sections.collect { | s | s.section_number }.uniq
  end


  def crosslisted_course_ids
    @sections.collect { | c | "#{c.alpha_prefix} #{c.course_number}" }.uniq
  end


  def reserves
    @reserves ||= reserve_search.instructor_reserves_for_course(self)
  end


  def published_reserves
    @published_reserves ||= reserve_search.student_reserves_for_course(self)
  end


  def reserve(id)
    reserve_search.get(id, self)
  end


  private

    def reserve_search
      @reserve_search ||= ReserveSearch.new
    end


    def banner_enrollment_netids
      @banner_enromment_netids ||= sections.collect{ | s | s.enrollment_netids }.flatten.reject(&:nil?).map { | s | s.downcase.strip }
    end


    def exception_enrollment_netids
      @exception_enrollment_netids ||= UserCourseException.course_enrollment_exceptions(self.id, self.term).collect { | e | e.netid.downcase.strip }
    end


    def banner_instructor_netids
      @banner_instructor_netids ||= sections.collect{ | s | s.instructor_netids }.flatten.uniq.reject(&:nil?).map { | s | s.downcase.strip }.map(&:downcase)
    end


    def exception_instructors_netids
      @exception_instructors_netids ||= UserCourseException.course_instructor_exceptions(self.id, self.term).collect { | e | e.netid.downcase.strip }.map(&:downcase)
    end


    def marshal_course_user(user, role, source)
      CourseUser.netid_factory(user, self, role, source)
    end

end
