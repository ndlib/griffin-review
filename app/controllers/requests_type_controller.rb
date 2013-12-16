class RequestsTypeController  < ApplicationController



  def edit
    check_admin_permission!

    @form = PhysicalElectronicReserveForm.build_from_params(self)
  end


  def update
    check_admin_permission!

    @form = PhysicalElectronicReserveForm.build_from_params(self)

    if @form.update_reserve_type!
      flash[:success] = 'The reserve type has been changed.'
      redirect_to request_path(@form.reserve.id)
    else
      flash[:error] = 'Unable to update the reserve type.  A reserve must be at least physical or electronic. '
      redirect_to edit_type_path(@form.reserve.id)
    end
  end


end
