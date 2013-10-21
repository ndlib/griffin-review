class OpenItem < OpenReserves
  self.table_name = 'item'
  self.primary_key = 'item_id'

  has_many :open_item_course_links, foreign_key: 'item_id'
  has_many :open_courses, :through => :open_item_course_links

  validates :title, :presence => true, :allow_nil => false
  validates :item_type, :presence => true, :inclusion => { :in => %w(article chapter book video music map journal mixed computer file) }

  scope :currently_used, lambda { |semester|
    joins(:courses).where(:course => {:term => semester})
  }

end
