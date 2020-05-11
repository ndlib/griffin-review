class RequestsWorkflowController  < ApplicationController

  def update
    check_admin_permission!

    @form = WorkflowStateForm.build_from_params(self)

    if @form.update_workflow_state!(current_user.display_name)
      flash[:success] = 'The reserve state has been changed.'
      redirect_to request_path(@form.reserve.id)
    else
      flash[:error] = 'Unable to update the reserve state.'
      redirect_to request_path(@form.reserve.id)
    end
  end


end
