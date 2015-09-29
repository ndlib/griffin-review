class ChangeDetailsToText < ActiveRecord::Migration
  def change
    change_column :items, :details, :text
  end
end
