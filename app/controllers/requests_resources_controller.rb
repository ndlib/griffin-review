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


  def destroy
    check_admin_permission!

    reserve = ReserveSearch.new.get(params[:id])
    @delete_form = DeleteReserveElectronicResourceForm.new(reserve)

    if @delete_form.remove!
      flash[:success] = "Electronic Resource Removed"
    else
      flash[:error] = "Unable to remove electronic resource.  Please try again or contact Jon."
    end

    redirect_to edit_resource_path(reserve.id)
  end

end
