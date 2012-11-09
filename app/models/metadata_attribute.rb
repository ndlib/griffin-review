class MetadataAttribute < ActiveRecord::Base

  has_many :technical_metadata, :dependent => :destroy, :class_name => "TechnicalMetadata" 
  has_many :technical_items, :through => :technical_metadata, :source => :item
  has_many :basic_metadata, :dependent => :destroy, :class_name => "BasicMetadata"
  has_many :basic_items, :through => :basic_metadata, :source => :item

  validates :name, :uniqueness => true
  validates :name, :definition, :metadata_type, :presence => true

end
