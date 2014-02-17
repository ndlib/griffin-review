class RequestsController  < ApplicationController

  def index
    check_admin_permission!

    @admin_request_listing = RequestList.new(self)

    respond_to do | format |
      format.html
      format.json
    end
  end


  def show
    check_admin_permission!
    @admin_reserve = RequestDetail.new(self)
  end


  def destroy
    @destroy = ReserveRemoveForm.new(current_user, params)

    @destroy.remove!

    redirect_to request_path(@destroy.reserve.id)
  end
end
