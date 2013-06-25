class Admin::RequestsResourcesController  < ApplicationController


  def edit
    @request = AdminUpdateResource.new(current_user, params)
  end


  def update
    @request = AdminUpdateResource.new(current_user, params)

    if @request.save_resource
      redirect_to requests_path(:filter => @request.workflow_state)
    else
      render 'edit'
    end
  end

  protected

    def reserves
      @reserves ||= ::ReservesAdminApp.new(params[:semester], "current_user")
    end

end
