class RequestsController  < ApplicationController

  def index
    check_admin_permission!
    @admin_request_listing = AdminReserveList.new(current_user, params)
  end


  def show
    check_admin_permission!
    @admin_reserve = AdminReserve.new(current_user, self, params)
  end
end
