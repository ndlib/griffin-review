class ChangeItemTitleField < ActiveRecord::Migration
  def change
    change_column :items, :title, :text
  end
end
