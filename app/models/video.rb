class Video < Item
  self.table_name = 'item'
  self.primary_key = 'item_id'

  validates :title, :presence => true, :allow_nil => false
  validates :item_type, :presence => true, :inclusion => { :in => %w(video) }

  def self.all_videos
    self.where(:item_type => 'video')
  end
end
