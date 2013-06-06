class InstructedCourse  < Course

  attr_accessor :cross_listings

  def section
    @attributes['sections']
  end


  def student_netids
    self.section.collect { | s | s['enrollments'] }.flatten
  end


  def instructor_name
    "#{self.instructors.first['first_name']} #{self.instructors.first['last_name']}"
  end


  def instructors
    self.section.first['instructors']
  end


  def term_code
    self.section.first['term']
  end


  def section_number
    self.section.collect { | s | s['section_number'] }
  end

  alias_method :section_numbers, :section_number


  def crosslistings
    @cross_listings ||= [self]
  end


  def add_crosslisted_course(course)
    @cross_listings ||= [self]
    @cross_listings << course
  end


  def crosslisted_course_ids

    crosslistings.collect { | c | c.id }
  end

end
