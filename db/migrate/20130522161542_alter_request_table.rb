class AlterRequestTable < ActiveRecord::Migration
  def up

    rename_table :video_workflows, :requests

    add_column :requests, :number_of_copies, :integer
    add_column :requests, :requestor_owns_a_copy, :string
    add_column :requests, :library, :string
    add_column :requests, :course_id, :string
    add_column :requests, :crosslist_id, :string
    add_column :requests, :requestor_netid, :string
    add_column :requests, :item_id, :integer

    add_index :requests, :library
    add_index :requests, :course_id
    add_index :requests, :crosslist_id
    add_index :requests, :requestor_netid
  end

  def down

    remove_column :requests, :number_of_copies
    remove_column :requests, :requestor_owns_a_copy
    remove_column :requests, :library
    remove_column :requests, :course_id
    remove_column :requests, :crosslist_id
    remove_column :requests, :requestor_netid
    remove_column :requests, :item_id

    rename_table :requests, :video_workflows
  end
end
