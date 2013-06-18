class Admin::RequestsResourcesController  < ApplicationController


  def edit
    @request = AdminUpdateResource.new(current_user, params)
  end


  def update
    @request = reserves.reserve(params[:id])
    redirect_to requests_path(@request.id, :filter => @request.status)
  end

  protected

    def reserves
      @reserves ||= ::ReservesAdminApp.new(params[:semester], "current_user")
    end

end
