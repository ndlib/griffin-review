class RemoveTokensToStoreOriginalToken < ActiveRecord::Migration
  def change
    remove_columm :wowza_tokens, :unhashed_token
  end
end
