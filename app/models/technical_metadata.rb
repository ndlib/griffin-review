class TechnicalMetadata < ActiveRecord::Base

  belongs_to :video_workflow, :foreign_key => 'vw_id'
  belongs_to :metadata_attribute, :foreign_key => 'ma_id'

  validates :value, :presence => true

end
