class AlterItemTable < ActiveRecord::Migration

  def up
    add_column :items, :creator, :string
    add_column :items, :title, :string
    add_column :items, :journal_title, :string
    add_column :items, :nd_meta_data_id, :string
    add_column :items, :overwrite_nd_meta_data, :boolean
    add_column :items, :length, :string
    add_column :items, :pdf_file_name, :string
    add_column :items, :pdf_file_size, :string
    add_column :items, :pdf_content_type, :string
    add_column :items, :pdf_updated_at, :string
    add_column :items, :url, :string
    add_column :items, :type, :string
    add_column :items, :publisher, :string

    add_index :items, :type
  end


  def down
    remove_column :items, :creator
    remove_column :items, :title
    remove_column :items, :journal_title
    remove_column :items, :nd_meta_data_id
    remove_column :items, :overwrite_nd_meta_data
    remove_column :items, :length
    remove_column :items, :file
    remove_column :items, :url
    remove_column :items, :type
    remove_column :items, :publisher
  end
end
