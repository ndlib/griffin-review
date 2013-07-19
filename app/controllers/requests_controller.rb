class RequestsController  < ApplicationController

  def index
    check_admin_permission!
    @admin_request_listing = AdminReserveList.new(current_user, params)
  end

end
