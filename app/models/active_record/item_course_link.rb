class ItemCourseLink < OpenReserves
  self.table_name = 'item_course_link'
  self.primary_key = 'item_course_link_id'

  belongs_to :open_item
  belongs_to :course

end
