class VideoWorkflow < ActiveRecord::Base
  include Workflow

  belongs_to :semester

  workflow do
    state :new do
      event :extricate, :transitions_to => :awaiting_processing
    end

    state :awaiting_processing
    
  end

end
