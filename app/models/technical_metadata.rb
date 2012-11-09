class TechnicalMetadata < ActiveRecord::Base

  belongs_to :item
  belongs_to :metadata_attribute

  validates :value, :presence => true

end
