class Video < Item
  self.table_name = 'item'
  self.primary_key = 'item_id'

  # has_many :item_course_links
  # has_many :courses, :through => :item_course_links

  attr_accessor :upload

  validates :title, :presence => true
  validates :item_type, :presence => true, :inclusion => { :in => %w(video) }

  default_scope where(:item_type => 'video')

  # scope :currently_used, lambda { |semester|
  #   joins(:courses).where(:course => {:term => semester})
  # }

  def self.all_videos
    self.where(:item_type => 'video')
  end


end
