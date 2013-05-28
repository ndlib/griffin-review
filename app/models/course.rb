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
    @all_tags.uniq!
  end


  def reserves
    self.class.reserve_test_data(self)
  end


  def published_reserves
    self.class.reserve_test_data(self).select { | r | r.workflow_state == 'available' }
  end


  def reserve(id)
    reserves[id.to_i - 1]
  end


  def self.reserve_test_data(course)
    Reserve

    [
      BookReserve.test_request(1, course),
      BookChapterReserve.test_request(2, course),
      JournalReserve.test_file_request(3, course),
      JournalReserve.test_url_request(4, course),
      VideoReserve.test_request(5, course),
      AudioReserve.test_request(6, course),
      BookReserve.new_request(7, course),
      BookReserve.awaiting_request(8, course),
      BookChapterReserve.new_request(9, course),
      BookChapterReserve.awaiting_request(10, course),
      VideoReserve.awaiting_request(11, course),
      VideoReserve.new_request(12, course),
    ]
  end


  def self.get_semester_from(course_id)
    course_id.split('_')[0]
  end

end
