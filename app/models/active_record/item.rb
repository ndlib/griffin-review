class Item < ActiveRecord::Base
#  attr_accessible :description, :item_type_id, :name, :basic_metadata_attributes, :technical_metadata_attributes

#  validates :name, :item_type, :description, :presence => true

#  belongs_to :item_type
#  has_many :technical_metadata, :dependent => :destroy, :class_name => "TechnicalMetadata"
#  has_many :basic_metadata, :dependent => :destroy, :class_name => "BasicMetadata"

#  accepts_nested_attributes_for :basic_metadata, :technical_metadata, :allow_destroy => true
end
