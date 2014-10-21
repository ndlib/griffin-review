class FixCreatedUpdatedAtColumns < ActiveRecord::Migration
  def up
    [:assignments, :items, :requests, :semesters, :users].each do |table_name|
      change_column table_name, :created_at, :datetime, null: true
      change_column table_name, :updated_at, :datetime, null: true
    end
  end

  def down
  end
end
