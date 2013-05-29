class Admin::RequestsMetaDataController  < ApplicationController

  layout 'admin'

  def edit
    @request = AdminUpdateMetaData.new(reserve)
  end


  def update
    @request = AdminUpdateMetaData.new(reserve, params[:admin_reserve])

    if @request.save_meta_data
      redirect_to requests_path(@request.id, :filter => @request.status)
    else
      render :edit
    end
  end


  protected

    def reserves
      @reserves ||= ::ReservesAdminApp.new(params[:semester], "current_user")
    end


    def reserve
      reserves.reserve(params[:id])
    end
end
