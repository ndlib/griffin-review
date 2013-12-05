class UpdateItem < ActiveRecord::Migration
  def change
    rename_column :items, :name, :selection_title
  end
end
