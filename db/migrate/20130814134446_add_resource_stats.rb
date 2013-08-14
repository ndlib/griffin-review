class AddResourceStats < ActiveRecord::Migration
  def change

    create_table :reserve_stats do | t |
      t.integer :request_id
      t.integer :item_id
      t.integer :semester_id
      t.integer :user_id
    end

    add_index :reserve_stats, :request_id
    add_index :reserve_stats, :item_id

  end
end
