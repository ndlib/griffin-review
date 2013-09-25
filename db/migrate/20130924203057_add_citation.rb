class AddCitation < ActiveRecord::Migration
  def change
    add_column :items, :citation, :text
  end
end
