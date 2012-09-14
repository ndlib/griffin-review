class AddValueToTechnicalMetadata < ActiveRecord::Migration
  def change
    add_column :technical_metadata, :value, :string
  end
end
