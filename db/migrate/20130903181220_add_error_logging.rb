class AddErrorLogging < ActiveRecord::Migration
  def change

    create_table :error_logs do | t |
      t.string :netid
      t.string :path
      t.string :message
      t.text :params
      t.text :stack_trace
      t.datetime :created_at
    end

  end
end
