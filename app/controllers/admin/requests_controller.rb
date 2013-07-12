class Admin::RequestsController  < ApplicationController

  def index
    check_admin_permission!
    @admin_request_listing = AdminRequestListing.new(current_user, params)
  end

end
