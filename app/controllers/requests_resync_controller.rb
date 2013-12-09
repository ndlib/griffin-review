class RequestsResyncController  < ApplicationController

  def update
    check_admin_permission!

    @button = ResyncReserveButton.build_from_params(self)

    if @button.resync!
      flash[:success] = 'Reserve has been re-synchronized.'
    else
      flash[:error] = 'Unable to re-synchronize the reserve.'
    end

    redirect_to edit_meta_data_path(@button.reserve.id)
  end

end
