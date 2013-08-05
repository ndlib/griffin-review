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
  end


  def course_triple
    sections.first['course_triple']
  end


  def reserve_id
    "#{self.crosslist_id}-#{self.section_group_id}"
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


  def enrollment_netids
    @enrollments ||= (
        sections.collect{ | s | s['enrollments']}.flatten +
        exception_enrollment_netids
      )
  end


  def instructor_name
    "#{primary_instructor['first_name']} #{primary_instructor['last_name']}"
  end


  def instructor_netid
    primary_instructor['netid']
  end


  def primary_instructor
    @attributes['primary_instructor']
  end


  def instructors
    @instructors ||= (
            sections.collect{ | s | s['instructors'] }.flatten.uniq{|x| x['netid']} +
            exception_instructors
        )
  end


  def instructor_netids
    instructors.collect { | c | c['netid'] }
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


  def default_course_data!
    Course.reserve_test_data(self).map { | r | r.save! }
  end


  def self.reserve_test_data(course)
    Reserve

    [
      BookReserve.test_request(course),
      BookChapterReserve.test_request(course),
      JournalReserve.test_file_request(course),
      JournalReserve.test_url_request(course),
      VideoReserve.test_request(course),
      AudioReserve.test_request(course),
      BookReserve.new_request(course),
      BookReserve.awaiting_request(course),
      BookChapterReserve.new_request(course),
      BookChapterReserve.awaiting_request(course),
      VideoReserve.awaiting_request(course),
      VideoReserve.new_request(course),
    ]
  end


  def self.get_semester_from(course_id)
    course_id.split('_')[0]
  end


  def crosslistings
    @crosslistings ||= [self]
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


    def exception_enrollment_netids
      UserCourseException.course_enrollment_exceptions(self.id, self.term).collect { | e | e.netid }
    end


    def exception_instructors
      UserCourseException.course_instructor_exceptions(self.id, self.term).collect { | i | { 'id' => i.netid, 'netid' => i.netid } }
    end
end
