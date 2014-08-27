class AddSortableTitleToRequests < ActiveRecord::Migration
  def change
    add_column :requests, :sortable_title, :text
  end
end
