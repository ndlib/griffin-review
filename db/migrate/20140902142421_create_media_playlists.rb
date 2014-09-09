class CreateMediaPlaylists < ActiveRecord::Migration
  def change
    create_table :media_playlists do |t|
      t.integer :item_id
      t.string :type
      t.text :data, :limit => 4294967295
    end

  end
end
