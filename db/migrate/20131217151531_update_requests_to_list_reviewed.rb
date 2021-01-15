class UpdateRequestsToListReviewed < ActiveRecord::Migration
  def change

    # add_column :requests, :reviewed, :boolean

    Request.update_all "reviewed = 1 where workflow_state != 'new'"
  end
end
