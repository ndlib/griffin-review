class AddUserExceptions < ActiveRecord::Migration

  def up

    create_table :user_course_exceptions do | t |
      t.string :netid
      t.string :role
    end

    add_index :user_course_exceptions, :netid
  end


  def down
    drop_table :user_course_exceptions
  end

end
