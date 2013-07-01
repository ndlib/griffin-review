class AddFairUse < ActiveRecord::Migration
  def up

    create_table :fair_uses, force: true do | t |
      t.text :fair_uses
      t.text :comments
      t.string :state
      t.integer :user_id
      t.integer :request_id
      t.integer :item_id
      t.timestamps
    end


    create_table :fair_use_questions, force: true do | t |
      t.text :question
      t.boolean :active
      t.string :category
      t.integer :ord
    end

    add_index :fair_uses, :item_id
    add_index :fair_uses, :request_id

    add_index :fair_use_questions, :ord
  end


  def down
    drop_table :fair_uses
    drop_table :fair_use_questions
  end

end
