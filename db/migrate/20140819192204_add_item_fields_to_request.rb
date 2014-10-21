class AddItemFieldsToRequest < ActiveRecord::Migration
  def change
    add_column :requests, :item_title, :text
    add_column :requests, :item_selection_title, :string
    add_column :requests, :item_type, :string
    add_column :requests, :item_physical_reserve, :boolean
    add_column :requests, :item_electronic_reserve, :boolean
  end
end
