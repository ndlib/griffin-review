class Course

  attr_accessor :title, :instructors, :cross_listings, :section

  def initialize(attributes = {})
    @attributes = attributes

    self.title = attributes['title']
    self.instructors= attributes['instructors']
    self.cross_listings = attributes['cross_listings'] || []
    self.section = attributes['section']
  end


  def id
    @attributes['crn']
  end


  def students
    []
  end


  def instructor_name
    "#{self.instructors.first['first_name']} #{self.instructors.first['last_name']}"
  end


  def all_tags
    @all_tags = []
    reserves.each{ | r | @all_tags = @all_tags + r.tags }
    @all_tags.uniq!
  end


  def reserves
    ReservesApp.reserve_test_data(self)
  end


  def published_reserves
    ReservesApp.reserve_test_data(self).select { | r | r.status == 'complete' }
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


end
