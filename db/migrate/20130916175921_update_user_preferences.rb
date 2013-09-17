class UpdateUserPreferences < ActiveRecord::Migration
  def change
    add_column :users, :admin_preferences, :string
  end
end
