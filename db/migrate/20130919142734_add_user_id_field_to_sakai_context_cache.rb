class AddUserIdFieldToSakaiContextCache < ActiveRecord::Migration
  def up
    add_column :sakai_context_cache, :user_id, :string
  end

  def down
    remove_column :sakai_context_cache, :user_id, :string
  end
end
