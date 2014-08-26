class UpdateItemsLength < ActiveRecord::Migration
  def change
    change_column :items, :length, :text
  end
end
