class CreateVideoQueues < ActiveRecord::Migration
  def change
    create_table :video_queues do |t|
      t.integer :user_id
      t.date :needed_by
      t.integer :semester_id
      t.string :title
      t.string :course
      t.boolean :repeat_request
      t.boolean :library_owned
      t.string :language
      t.boolean :subtitles
      t.text :note
      t.boolean :request_processed
      t.datetime :date_processed
      t.integer :processed_by

      t.timestamps
    end
  end
end
