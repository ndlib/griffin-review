class CreateSemesters < ActiveRecord::Migration
  def change
    create_table :semesters do |t|
      t.string :code
      t.string :full_name
      t.date :date_begin
      t.date :date_end

      t.timestamps
    end
  end
end
