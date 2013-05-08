class Admin::RequestsResourcesController  < ApplicationController

  layout 'admin'

  def edit
    @request = reserves.reserve(params[:id])
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
