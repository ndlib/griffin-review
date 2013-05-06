class BasicMetadata < ActiveRecord::Base
  attr_accessible :item_id, :metadata_attribute_id, :value

  belongs_to :item
  belongs_to :metadata_attribute

  validates :value, :presence => true
  
end
