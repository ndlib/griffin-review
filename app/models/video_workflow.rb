class VideoWorkflow < ActiveRecord::Base
  include Workflow

  attr_accessor :workflow_transition

  belongs_to :semester
  belongs_to :workflow_state_user, :class_name => "User", :foreign_key => 'workflow_state_change_user'
  has_many :technical_metadata, :dependent => :destroy, :class_name => "TechnicalMetadata", :foreign_key => 'vw_id'
  has_many :metadata_attributes, :through => :technical_metadata
  accepts_nested_attributes_for :technical_metadata

  workflow do
    state :new, :meta => {:label => 'New', :color => '#2929FF'} do
      event :request_from_acquisitions, :transitions_to => :awaiting_acquisitions, :meta => {:label => 'Requested from Acquisitions'}
      event :digitize, :transitions_to => :digitized, :meta => {:label => 'Digitized'}
      event :convert_for_streaming, :transitions_to => :converted, :meta => {:label => 'Converted'}
    end
    
    state :awaiting_acquisitions, :meta => {:label => 'Awaiting Acquisitions', :color => '#567B6C'} do
      event :send_to_cataloging, :transitions_to => :awaiting_cataloging, :meta => {:label => 'Cataloging'}
    end

    state :awaiting_cataloging, :meta => {:label => 'Cataloging', :color => '#7D7135'} do
      event :digitize, :transitions_to => :digitized, :meta => {:label => 'Digitized'}
      event :convert_for_streaming, :transitions_to => :converted, :meta => {:label => 'Converted'}
    end
    
    state :digitized, :meta => {:label => 'Digitized', :color => '#7D5426'} do
      event :convert_for_streaming, :transitions_to => :converted, :meta => {:label => 'Converted'}
      event :upload, :transitions_to => :uploaded, :meta => {:label => 'Uploaded'}
    end

    state :converted, :meta => {:label => 'Converted for Streaming', :color => '#7D3209'} do
      event :upload, :transitions_to => :uploaded, :meta => {:label => 'Uploaded'}
    end
    
    state :uploaded, :meta => {:label => 'Uploaded', :color => '#47507D'} do
      event :complete, :transitions_to => :completed, :meta => {:label => 'Processing Complete'}
    end

    state :completed, :meta => {:label => 'Completed', :color => '#1E6512'}
    
  end

end
