class RemoveTokensToStoreOriginalToken < ActiveRecord::Migration
  def change
    remove_column :wowza_tokens, :unhashed_token
  end
end
