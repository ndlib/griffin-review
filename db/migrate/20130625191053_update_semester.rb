class UpdateSemester < ActiveRecord::Migration
  def up

    add_column :semesters, :movie_directory, :string
  end

  def down

    remove_column :semesters, :movie_directory
  end
end
