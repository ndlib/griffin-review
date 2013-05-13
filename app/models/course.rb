class Course

  attr_accessor :title, :instructors, :cross_listings, :section, :semester_code

  def initialize(attributes = {})
    @attributes = attributes

    self.title = attributes['title']
    self.instructors= attributes['instructors']
    self.cross_listings = attributes['cross_listings'] || []
    self.section = attributes['section']
    self.semester_code = attributes['term_prefix']
  end


  def id
    @attributes['term_crn']
  end


  def students
    []
  end


  def instructor_name
    "#{self.instructors.first['first_name']} #{self.instructors.first['last_name']}"
  end


  def semester

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
    self.class.reserve_test_data(self).select { | r | r.status == 'complete' }
  end


  def reserve(id)
    reserves[id.to_i - 1]
  end


  def new_reserve(*args)
    args[0] ||= {}
    args[0][:course] = self

    Reserve.new(*args)
  end


  def new_instructor_request(*args)
    raise "fix"
    InstructorReserveRequest.new(self.new_reserve(*args), self.current_user)
  end


  def get_reserve(id)
    raise "fix"
    GetReserve.new(self.reserve(id), self.current_user)
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
