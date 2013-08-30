class MigrateCrosslistIds < ActiveRecord::Migration
  def change

    UpdateReserveData.process_requests

    rename_column :user_course_exceptions, :section_group_id, :course_id
    UpdateReserveData.process_exceptions
  end
end
