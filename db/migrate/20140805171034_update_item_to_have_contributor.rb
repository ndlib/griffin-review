class UpdateItemToHaveContributor < ActiveRecord::Migration
  def change
    add_column :items, :contributor, :string
  end
end
