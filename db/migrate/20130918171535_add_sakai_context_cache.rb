class AddSakaiContextCache < ActiveRecord::Migration
  def up
    
    create_table :sakai_context_cache, force: true do | t |
      t.string :context_id
      t.string :external_id
      t.string :course_id
      t.string :term
      t.timestamps
    end

    add_index :sakai_context_cache, :context_id 
    add_index :sakai_context_cache, :external_id 
    add_index :sakai_context_cache, :course_id 
    add_index :sakai_context_cache, :term 
  end

  def down
    drop_table :sakai_context_cache
  end
end
