class Course
  attr_accessor :title, :instructor

  def initialize(attributes = {})
    self.title = attributes[:title]
    self.instructor = 'Instructor'
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


  def instructors

  end


  def reserves
    CourseListing

    [
      BookListing.test_request,
      BookChapterListing.test_request,
      JournalListing.test_file_request,
      JournalListing.test_url_request,
      VideoListing.test_request,
      AudioListing.test_request,
      WebsiteListing.test_request
    ]
  end

end
