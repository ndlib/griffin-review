class AddItemOnOrderToRequests < ActiveRecord::Migration
  def change
    add_column :requests, :item_on_order, :boolean
  end
end
