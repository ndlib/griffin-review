class Course
  attr_accessor :attributes, :crosslistings


  def initialize(attributes)
    @attributes = attributes
  end


  def self.factory(attributes = {})
    Course.new(attributes)
  end


  def id
    self.section_group_id
    #self.crosslist_id
  end


  def course_triple
    sections.first['course_triple']
  end


  def crosslist_id
    @attributes['crosslist_id']
  end


  def section_group_id
    @attributes['section_group_id'] || @attributes['section_groups'].first['section_group_id']
  end


  def title
    sections.first['course_title']
  end


  def full_title
    "#{title} - #{semester_name}"
  end


  def sections
    @attributes['sections']
  end


  def course_code
    course_triple.gsub("#{term}_",'').gsub('_',' ')
  end


  def alpha_prefix
    @attributes['alpha_prefix']
  end


  def number
    @attributes['number']
  end


  def unique_supersection_ids
    @attributes['sections'].collect {|s| s["supersection_id"]}.uniq
  end


  def add_enrollment_exception!(netid)
    UserCourseException.create_enrollment_exception!(self.id, self.term, netid)
  end


  def enrollments
    @enrollments ||= (
      banner_enrollment_netids.collect { | netid | marshal_course_user(netid, 'enrollment', 'banner') } +
      exception_enrollment_netids.collect { | netid | marshal_course_user(netid, 'enrollment', 'exception') }
    )
  end


  def enrollment_netids
    @enrollments ||= banner_enrollment_netids + exception_enrollment_netids
  end


  def instructor_netid
    primary_instructor.username
  end


  def primary_instructor
    @primary_instructor ||= marshal_course_user(@attributes['primary_instructor']['netid'], 'instructor', 'banner')
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


  def add_instructor_exception!(netid)
    UserCourseException.create_instructor_exception!(self.id, self.term, netid)
  end


  def term
    sections.first['term']
  end


  def semester_name
    semester.full_name
  end


  def semester
    @semeseter ||= Semester.semester_for_code(term)
  end


  def section_numbers
    sections.collect { | s | s['section_number']}
  end


  def all_topics
    @all_tags = []
    reserves.each{ | r | @all_tags = @all_tags + r.topics }
    @all_tags.uniq
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



  def crosslistings
    @crosslistings ||= [ self ]
  end


  def add_crosslisted_course(course)
    @crosslistings ||= [self]
    @crosslistings << course
  end


  def crosslisted_course_ids
    crosslistings.collect { | c | c.course_code }
  end


  private

    def reserve_search
      @reserve_search ||= ReserveSearch.new
    end


    def banner_enrollment_netids
      @banner_enromment_netids ||= sections.collect{ | s | s['enrollments']}.flatten
    end


    def exception_enrollment_netids
      @exception_enrollment_netids ||= UserCourseException.course_enrollment_exceptions(self.id, self.term).collect { | e | e.netid }
    end


    def banner_instructor_netids
      @banner_instructor_netids ||= sections.collect{ | s | s['instructors'] }.flatten.collect{ | i | i['netid'] }.uniq
    end


    def exception_instructors_netids
      @exception_instructors_netids ||= UserCourseException.course_instructor_exceptions(self.id, self.term).collect { | e | e.netid }
    end

    def marshal_course_user(user, role, source)
      CourseUser.netid_factory(user, self, role, source)
    end

end
