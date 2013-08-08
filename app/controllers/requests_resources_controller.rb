class RequestsResourcesController  < ApplicationController


  def edit
    check_admin_permission!
    @request = AdminUpdateResource.new(current_user, params)
  end


  def update
    check_admin_permission!
    @request = AdminUpdateResource.new(current_user, params)

    if @request.save_resource
      flash[:success] = "Resource Saved"
      redirect_to request_path(@request.id)
    else
      render 'edit'
    end
  end

end
