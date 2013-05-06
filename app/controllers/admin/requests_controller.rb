class Admin::RequestsController  < ApplicationController

  layout 'admin'

  def index
    reserves

    if params[:filter] == 'complete'
      @reserve_list = reserves.completed_reserves
    elsif params[:filter] == 'all'
      @reserve_list = reserves.all_reserves
    else
      @reserve_list = reserves.in_complete_reserves
    end
  end


  def edit
    @request = reserves.edit_admin_reserve(params[:id])
  end


  def create
    redirect_to requests_path
  end


  protected

    def reserves
      @reserves ||= ReservesAdmin.new(params[:semester], "current_user")
    end

end
