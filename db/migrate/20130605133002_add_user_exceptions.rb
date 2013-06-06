class AddUserExceptions < ActiveRecord::Migration

  def up

    create_table :user_course_exceptions, force: true do | t |
      t.string :netid
      t.string :role
      t.string :section_id
      t.string :semester_code
    end

    add_index :user_course_exceptions, [ :netid, :semester_code ]
  end


  def down
    drop_table :user_course_exceptions
  end

end
