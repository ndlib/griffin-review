class MetadataAttribute < ActiveRecord::Base

  validates :name, :uniqueness => true
  validates :name, :definition, :presence => true

end
