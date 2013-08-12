class AddItemDisplayLength < ActiveRecord::Migration
  def change
    add_column :items, :display_length, :string
  end
end
