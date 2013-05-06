class Course

  attr_accessor :title, :instructor, :cross_listings, :current_user

  def initialize(attributes = {})
    self.title = attributes['title']
    self.instructor = attributes[:instructor]
    self.cross_listings = attributes[:cross_listings] || []
    self.current_user = attributes[:current_user]
  end

=begin < OpenReserves
  self.table_name = 'course'
  self.primary_key = 'course_id'

  has_many :item_course_links
  has_many :items, :through => :item_course_links

  validates :course_id, :instructor_firstname, :instructor_lastname, :presence => true

  scope :currently_available, lambda { |semester|
    where('term like ?', semester + "%")
  }
=end

  def self.enrolled_courses(netid, semester)
    ret = []
    API::Person.courses(netid, semester)['enrolled_courses'].each do | c |
      ret << Course.new(c)
    end

    ret
  end


  def id
    1
  end


  def students
    []
  end


  def instructor
    "need to get instructor"
  end


  def all_tags
    @all_tags = []
    reserves.each{ | r | @all_tags = @all_tags + r.tags }
    @all_tags.uniq!
  end


  def reserves
    ReservesApp.reserve_test_data
  end


  def published_reserves
    ReservesApp.reserve_test_data.select { | r | r.status == 'complete' }
  end


  def reserve(id)
    reserves[id.to_i - 1]
  end


  def self.test_data(current_user, title = 'Course 1')
    listings = Random.rand(4).times.collect { | c | "Cross Listing #{c + 1}"}
    Course.new('title' => title, instructor: 'Instructor', cross_listings: listings, current_user: current_user)
  end


  def new_reserve(*args)
    args[0] ||= {}
    args[0][:course] = self

    Reserve.new(*args)
  end


  def new_instructor_request(*args)
    InstructorReserveRequest.new(self.new_reserve(*args), self.current_user)
  end


  def get_reserve(id)
    GetReserve.new(self.reserve(id), self.current_user)
  end

end
