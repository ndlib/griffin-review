class AddUserIdIndexToSakaiContextCache < ActiveRecord::Migration
  def up
    add_index :sakai_context_cache, :user_id
  end
  
  def down
    remove_index :sakai_context_cache, :user_id
  end
end
