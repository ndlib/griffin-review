class FixErrorLogMessageLength < ActiveRecord::Migration
  def change
    change_column :error_logs, :message, :text
  end
end
