class AddTypeFieldToMetadataAttributesTable < ActiveRecord::Migration
  def up
    add_column :metadata_attributes, :type, :string
  end

  def down
    drop_column :metadata_attributes, :type
  end
end
