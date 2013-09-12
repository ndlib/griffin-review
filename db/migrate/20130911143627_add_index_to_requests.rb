class AddIndexToRequests < ActiveRecord::Migration
  def change
    add_index :requests, :workflow_state
  end
end
