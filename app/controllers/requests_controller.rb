class RequestsController  < ApplicationController

  def index
    check_admin_permission!

    @admin_request_listing = ListRequests.build_from_params(self)

    respond_to do | format |
      format.html
      format.json
    end
  end


  def show
    check_admin_permission!
    @admin_reserve = RequestDetail.new(self)
    @workflow_state_form = WorkflowStateForm.build_from_params(self)
    @library_form = LibraryReserveForm.build_from_params(self)
    @needed_by_form = NeededByReserveForm.build_from_params(self)
    @required_material_form = RequiredMaterialReserveForm.build_from_params(self)
  end


  def destroy
    @destroy = ReserveRemoveForm.new(current_user, params)

    @destroy.remove!

    redirect_to request_path(@destroy.reserve.id)
  end
end
