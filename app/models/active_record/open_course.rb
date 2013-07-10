class OpenCourse < OpenReserves

  self.table_name = 'course'
  self.primary_key = 'course_id'

  has_many :open_item_course_links, foreign_key: 'course_id'
  has_many :open_items, :through => :open_item_course_links


  def reserves
    open_items
  end
end
