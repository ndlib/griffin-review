class Course

  attr_accessor :title, :instructor, :cross_listings

  def initialize(attributes = {})
    self.title = attributes[:title]
    self.instructor = attributes[:instructor]
    self.cross_listings = attributes[:cross_listings] || []
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

  def id
    1
  end


  def students
    []
  end


  def all_tags
    @all_tags = []
    reserves.each{ | r | @all_tags = @all_tags + r.tags }
    @all_tags.uniq!
  end


  def reserves
    CourseListing

    [
      BookListing.test_request(1),
      BookChapterListing.test_request(2),
      JournalListing.test_file_request(3),
      JournalListing.test_url_request(4),
      VideoListing.test_request(5),
      AudioListing.test_request(6),
      WebsiteListing.test_request(7)
    ]
  end


  def reserve(id)
    reserves[id.to_i - 1]
  end


  def self.test_data(title = 'Course 1')
    listings = Random.rand(4).times.collect { | c | "Cross Listing #{c + 1}"}
    Course.new(title: title, instructor: 'Instructor', cross_listings: listings)
  end


  def new_request(*args)
    Request.new(*args)
  end

end
