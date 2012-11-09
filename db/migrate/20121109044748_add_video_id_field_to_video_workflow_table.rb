class AddVideoIdFieldToVideoWorkflowTable < ActiveRecord::Migration
  def up
    add_column :video_workflows, :video_id, :integer
  end
  def down
    drop_column :video_workflows, :video_id
  end
end
