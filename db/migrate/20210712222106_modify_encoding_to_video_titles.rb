class ModifyEncodingToVideoTitles < ActiveRecord::Migration
  def self.up
    execute "ALTER TABLE reserves_development.video_titles MODIFY name VARCHAR(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci;"
  end

  def self.down
    execute "ALTER TABLE reserves_development.video_titles MODIFY name VARCHAR(255) CHARACTER SET latin1;"
  end
end
