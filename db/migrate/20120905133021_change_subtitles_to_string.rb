class ChangeSubtitlesToString < ActiveRecord::Migration
  def up
    change_column :video_workflows, :subtitles, :string
  end

  def down
    change_column :video_workflows, :subtitles, :boolean
  end
end
