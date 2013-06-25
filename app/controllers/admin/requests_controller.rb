class Admin::RequestsController  < ApplicationController

  def index
    @admin_request_listing = AdminRequestListing.new(current_user, params)
  end


  def edit
    @request = reserves.edit_admin_reserve(params[:id])
  end


  def create
    redirect_to requests_path
  end


  protected

    def reserves
      @reserves ||= ::ReservesAdminApp.new(current_user, params[:semester])
    end

end
