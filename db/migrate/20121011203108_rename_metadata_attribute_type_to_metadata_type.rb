class RenameMetadataAttributeTypeToMetadataType < ActiveRecord::Migration
  def up
    rename_column :metadata_attributes, :type, :metadata_type 
  end

  def down
    rename_column :metadata_attributes, :metadata_type, :type 
  end
end
