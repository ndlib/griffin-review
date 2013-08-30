class MigrateCrosslistIds < ActiveRecord::Migration
  def change

    UpdateReserveData.process_requests
    UpdateReserveData.process_exceptions

    remove_column :requests, :crosslist_id

    rename_column :user_course_exceptions, :section_group_id, :course_id
  end
end
