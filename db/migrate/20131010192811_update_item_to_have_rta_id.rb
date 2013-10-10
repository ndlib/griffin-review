class UpdateItemToHaveRtaId < ActiveRecord::Migration
  def change

    add_column :items, :realtime_availability_id, :string
  end
end
