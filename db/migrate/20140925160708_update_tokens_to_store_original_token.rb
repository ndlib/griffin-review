class UpdateTokensToStoreOriginalToken < ActiveRecord::Migration
  def change
    add_column :wowza_tokens, :unhashed_token, :string
  end
end
