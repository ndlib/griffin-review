class AddMetadataSynchronizationDate < ActiveRecord::Migration
  def change

    add_column :items, :metadata_synchronization_date, :datetime
  end
end
