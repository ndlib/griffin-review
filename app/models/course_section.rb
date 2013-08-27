class CourseSection
  attr_accessor :attributes, :crosslist_id


  def self.factory(crosslist_id, attributes = {})
    attributes[:crosslist_id] = crosslist_id
    CourseSection.new(attributes)
  end


  def initialize(attributes)
    @attributes = attributes.with_indifferent_access
  end


  def id
    @attributes[:section_id]
  end


  def supersection_id
    @attributes[:supersection_id]
  end


  def triple
    @attributes[:course_triple]
  end


  def crosslist_id
    @attributes[:crosslist_id]
  end


  def title
    @attributes[:course_title]
  end


  def full_title
    "#{title} - #{semester.name}"
  end


  def alpha_prefix
    @attributes[:alpha_prefix]
  end


  def section_number
    @attributes[:section_number]
  end


  def enrollment_netids
    @attributes[:enrollments]
  end


  def instructor_netids
    @attributes[:instructors].collect { | i | i[:netid] }
  end


  def term
    @attributes[:term]
  end


  def semester
    @semeseter ||= Semester.semester_for_code(term)
  end

end
