class MigrateLibraryFieldInRequests < ActiveRecord::Migration
  def change

    Request.update_all(library: 'hesburgh')
  end
end
