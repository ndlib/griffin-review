class CreateNotes < ActiveRecord::Migration
  def up
    create_table :messages do |t|
        t.string :creator
        t.timestamps
        t.text :content
        t.references :request, index: true, foreign_key: true
    end
  end

  def down
    drop_table :messages
  end
end
