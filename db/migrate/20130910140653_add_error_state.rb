class AddErrorState < ActiveRecord::Migration
  def change
    add_column :error_logs, :state, :string
    ErrorLog.update_all(state: 'new')
  end
end
