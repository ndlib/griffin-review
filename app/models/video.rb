class Video < Item
  attr_accessible :description, :item_type_id, :name
  
  has_many :video_workflows

  default_scope :include => :item_type, :conditions => { 'item_types.name' => 'Video' }
end
