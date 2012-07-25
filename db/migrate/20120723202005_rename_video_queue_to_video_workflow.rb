class RenameVideoQueueToVideoWorkflow < ActiveRecord::Migration
  def up
    rename_table :video_queues, :video_workflows
  end

  def down
    rename_table :video_workflows, :video_queues
  end
end
