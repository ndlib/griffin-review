class DuplicateAndStoreOldRequests < ActiveRecord::Migration
  def change
    execute "CREATE TABLE save_requests LIKE requests"
    Request.delete_all
  end
end
