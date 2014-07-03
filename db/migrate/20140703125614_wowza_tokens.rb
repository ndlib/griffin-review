class WowzaTokens < ActiveRecord::Migration
  def change

    create_table :wowza_tokens do | t |

      t.string :username
      t.string :token
      t.string :ip
      t.string :timestamp

      t.timestamps
    end

    add_index :wowza_tokens, :token

  end
end
