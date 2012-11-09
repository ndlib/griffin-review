class CreateBasicMetadata < ActiveRecord::Migration
  def change
    create_table :basic_metadata do |t|
      t.integer :metadata_attribute_id
      t.integer :item_id
      t.string :value

      t.timestamps
    end
  end
end
