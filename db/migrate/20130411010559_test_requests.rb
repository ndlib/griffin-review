class TestRequests < ActiveRecord::Migration
  def up
    create_table :test_requests, :force => true do | t |
      t.string :title
      t.string :author
      t.string :type
      t.text :data
      t.timestamps
    end

    add_index :test_requests, :type
  end

  def down
    drop_table :test_requests
  end
end
