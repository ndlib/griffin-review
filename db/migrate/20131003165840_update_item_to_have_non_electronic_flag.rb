class UpdateItemToHaveNonElectronicFlag < ActiveRecord::Migration
  def change

    add_column :items, :physical_reserve, :boolean

  end
end
