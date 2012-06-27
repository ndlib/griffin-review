class Course < OpenReserves
  self.table_name = 'course'
  self.primary_key = 'course_id'

  has_many :item_course_links
  has_many :items, :through => :item_course_links

  validates :course_id, :instructor_firstname, :instructor_lastname, :presence => true

  scope :currently_available, lambda { |semester|
    where('term like ?', semester + "%")
  }

end
