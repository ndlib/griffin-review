class FixWowzaTokensTimestampLimit < ActiveRecord::Migration
  def up
    change_column :wowza_tokens, :timestamp, :integer, limit: nil
  end

  def down
  end
end
