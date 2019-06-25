class AddRequiredMaterialsToRequest < ActiveRecord::Migration
  def change
    add_column :requests, :required_material, :boolean
  end
end
