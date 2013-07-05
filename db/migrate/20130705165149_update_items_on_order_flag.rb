class UpdateItemsOnOrderFlag < ActiveRecord::Migration

  def up
    add_column :items, :on_order, :boolean
    add_column :items, :details, :string
  end

  def down
    remove_column :items, :on_order
    remove_column :items, :details
  end

end
