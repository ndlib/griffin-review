class RenameTechnicalMetadataJoinFields < ActiveRecord::Migration
  def up
    rename_column :technical_metadata, :vw_id, :item_id 
    rename_column :technical_metadata, :ma_id, :metadata_attribute_id 
  end

  def down
    rename_column :technical_metadata, :item_id, :vw_id 
    rename_column :technical_metadata, :metadata_attribute_id, :ma_id
  end
end
