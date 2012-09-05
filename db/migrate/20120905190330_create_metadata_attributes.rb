class CreateMetadataAttributes < ActiveRecord::Migration
  def change
    create_table :metadata_attributes do |t|
      t.string :name
      t.text :definition

      t.timestamps
    end
  end
end
