class Admin::RequestsMetaDataController  < ApplicationController

  layout 'admin'

  def edit
    @request = reserves.reserve(params[:id])
  end


  protected

    def reserves
      @reserves ||= ReservesAdmin.new(params[:semester], "current_user")
    end

end
