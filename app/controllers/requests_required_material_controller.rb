class RequestsRequiredMaterialController  < ApplicationController

    def update
      check_admin_permission!
  
      @form = RequiredMaterialReserveForm.build_from_params(self)
  
      if @form.update_reserve_required_material!
        flash[:success] = 'The reserve required material setting has been changed.'
        redirect_to request_path(@form.reserve.id)
      else
        flash[:error] = 'Unable to update the reserve required material setting.'
        redirect_to request_path(@form.reserve.id)
      end
    end
  
  end