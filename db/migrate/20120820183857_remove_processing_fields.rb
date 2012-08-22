class RemoveProcessingFields < ActiveRecord::Migration
  def up
    remove_column :video_workflows, :request_processed
    remove_column :video_workflows, :date_processed
    remove_column :video_workflows, :processed_by
  end

  def down
    add_column :video_workflows, :request_processed, :boolean
    add_column :video_workflows, :date_processed, :datetime
    add_column :video_workflows, :processed_by, :integer
  end
end
