class CreateTechnicalMetadata < ActiveRecord::Migration
  def change
    create_table :technical_metadata do |t|
      t.integer :vw_id
      t.integer :ma_id

      t.timestamps
    end
  end
end
