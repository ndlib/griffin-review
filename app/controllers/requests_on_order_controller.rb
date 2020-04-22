class RequestsOnOrderController  < ApplicationController

  def update
    check_admin_permission!

    reserve = ReserveSearch.new.get(params[:id])
    @place_on_order_form = PlaceItemOnOrderForm.new(reserve)

    if @place_on_order_form.toggle_on_order!(current_user.display_name)
      flash[:success] = @place_on_order_form.update_message
    else
      flash.now[:error] = "Unable to place this item on order.  Please try again or contact Jon."
    end

    redirect_to request_path(@place_on_order_form.id)
  end

end
