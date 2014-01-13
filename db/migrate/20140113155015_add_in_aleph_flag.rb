class AddInAlephFlag < ActiveRecord::Migration
  def change
    add_column :requests, :currently_in_aleph, :boolean
  end
end
