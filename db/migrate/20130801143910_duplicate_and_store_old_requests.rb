class DuplicateAndStoreOldRequests < ActiveRecord::Migration
  def change
    execute "CREATE TABLE save_requests LIKE requests"
    execute "INSERT INTO save_requests SELECT * FROM requests"

    Request.delete_all
  end
end
