class AddUserExceptions < ActiveRecord::Migration

  def up

    create_table :user_course_exceptions, force: true do | t |
      t.string :netid
      t.string :role
      t.string :section_group_id
      t.string :term
    end

    add_index :user_course_exceptions, [ :section_group_id, :term, :role ], name: 'uce_search_index'
    add_index :user_course_exceptions, [ :netid, :term ]
  end


  def down
    drop_table :user_course_exceptions
  end

end
