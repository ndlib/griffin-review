class AddDefaultToRequestProcessedVideoWorkflow < ActiveRecord::Migration
  def change
    change_column :video_workflows, :request_processed, :boolean, :default => 0, :null => false
  end
end
