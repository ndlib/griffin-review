class RequestsLibraryController  < ApplicationController

  def update
    check_admin_permission!

    @form = LibraryReserveForm.build_from_params(self)

    if @form.update_reserve_library!
      flash[:success] = 'The reserve fulfillment library has been changed.'
      redirect_to request_path(@form.reserve.id)
    else
      flash[:error] = 'Unable to update the reserve fulfillment library.'
      redirect_to request_path(@form.reserve.id)
    end
  end


end
