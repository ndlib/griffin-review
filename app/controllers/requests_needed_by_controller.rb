class RequestsNeededByController  < ApplicationController

  def update
    check_admin_permission!

    @form = NeededByReserveForm.build_from_params(self)

    if @form.update_reserve_needed_by!
      flash[:success] = 'The reserve needed by date has been changed.'
      redirect_to request_path(@form.reserve.id)
    else
      flash[:error] = 'Unable to update the reserve needed by date.'
      redirect_to request_path(@form.reserve.id)
    end
  end

end
