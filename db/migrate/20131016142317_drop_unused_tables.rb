class DropUnusedTables < ActiveRecord::Migration
  def change

    #drop_table :assignments
    drop_table :basic_metadata
    drop_table :item_types
    drop_table :metadata_attributes
    drop_table :roles
    drop_table :save_requests
    drop_table :taggings
    drop_table :tags
    drop_table :technical_metadata
    drop_table :test_requests
  end
end
