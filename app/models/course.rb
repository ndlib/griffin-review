class Course

  def initialize(attributes)
    @attributes = attributes
  end


  def self.factory(attributes = {})
    if attributes.has_key?('sections')
      InstructedCourse.new(attributes)
    else
      Course.new(attributes)
    end
  end


  def id
    @attributes['course_id']
  end


  def reserve_id
    "#{self.crosslist_id}-#{self.section_group_id}"
  end


  def crosslist_id
    @attributes['crosslist_id']
  end


  def section_group_id
    @attributes['section_group_id']
  end


  def title
    @attributes['course_title']
  end


  def section
    @attributes['section']
  end


  def student_netids
    self.section['enrollments']
  end


  def instructor_name
    "#{self.instructors.first}"
  end


  def instructors
    self.section['instructors']
  end


  def term_code
    self.section['term']
  end


  def section_number
    self.section['section_number']
  end


  def all_tags
    @all_tags = []
    reserves.each{ | r | @all_tags = @all_tags + r.tags }
    @all_tags.uniq
  end


  def reserves
    reserve_search.instructor_reserves_for_course(self)
  end


  def published_reserves
    reserve_search.student_reserves_for_course(self)
  end


  def reserve(id)
    reserve_search.get(id, self)
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


  def default_course_data!
    Course.reserve_test_data(self).map { | r | r.save! }
  end

  private

    def reserve_search
      @reserve_search ||= ReserveSearch.new
    end

end
