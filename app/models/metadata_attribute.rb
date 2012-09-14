class MetadataAttribute < ActiveRecord::Base

  has_many :technical_metadata, :dependent => :destroy, :class_name => "TechnicalMetadata", :foreign_key => 'ma_id'
  has_many :video_workflows, :through => :technical_metadata

  validates :name, :uniqueness => true
  validates :name, :definition, :presence => true

end
