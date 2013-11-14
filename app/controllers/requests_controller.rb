class RequestsController  < ApplicationController

  def index
    check_admin_permission!
    @admin_request_listing = AdminReserveList.new(self)

    respond_to do | format |
      format.html
      format.json
    end
  end


  def show
    check_admin_permission!
    @admin_reserve = RequestDetail.new(self)
  end


end
