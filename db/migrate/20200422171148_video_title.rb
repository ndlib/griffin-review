class VideoTitle < ActiveRecord::Migration
  def up
    create_table :video_titles do |t|
      t.column :name, :string
    end
  end

  def down
    drop_table :video_titles
  end
end
