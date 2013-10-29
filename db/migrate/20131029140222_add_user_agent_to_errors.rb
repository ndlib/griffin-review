class AddUserAgentToErrors < ActiveRecord::Migration
  def change

    add_column :error_logs, :user_agent, :text
    add_column :error_logs, :exception_class, :string
  end
end
