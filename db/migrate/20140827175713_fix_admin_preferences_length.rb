class FixAdminPreferencesLength < ActiveRecord::Migration
  def up
    change_column :users, :admin_preferences, :text
  end

  def down
    change_column :users, :admin_preferences, :string
  end
end
