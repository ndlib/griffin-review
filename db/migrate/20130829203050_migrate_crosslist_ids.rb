class MigrateCrosslistIds < ActiveRecord::Migration
  def change

    UpdateReserveData.process_requests
    UpdateReserveData.process_exceptions

    remove_column :requests, :crosslist_id

  end
end
