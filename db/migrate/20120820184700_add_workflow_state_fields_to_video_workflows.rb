class AddWorkflowStateFieldsToVideoWorkflows < ActiveRecord::Migration
  def up
    add_column :video_workflows, :workflow_state, :string
    add_column :video_workflows, :workflow_state_change_date, :datetime
    add_column :video_workflows, :workflow_state_change_user, :integer
  end

  def down
    drop_column :video_workflows, :workflow_state
    drop_column :video_workflows, :workflow_state_change_date
    drop_column :video_workflows, :workflow_state_change_user
  end
end
