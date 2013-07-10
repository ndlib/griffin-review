class OpenItemCourseLink < OpenReserves
  self.table_name = 'item_course_link'
  self.primary_key = 'item_course_link_id'

  belongs_to :open_item, foreign_key: 'item_id'
  belongs_to :open_course, foreign_key: 'course_id'

end
