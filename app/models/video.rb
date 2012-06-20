class Video < Item
  self.table_name = 'item'
  self.primary_key = 'item_id'

  attr_accessor :upload

  validates :title, :presence => true
  validates :item_type, :presence => true, :inclusion => { :in => %w(video) }

  def self.all_videos
    self.where(:item_type => 'video')
  end


end
