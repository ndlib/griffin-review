
class PlaceItemOnOrderForm

  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  attr_accessor :reserve

  def initialize(reserve)
    @reserve = reserve
  end


  def id
    @reserve.id
  end


  def toggle_on_order!(*additions)
    if @reserve.on_order
      @reserve.workflow_state = 'inprocess'
      @reserve.on_order = false
      msg = "Item no longer to be purchased."
    else
      @reserve.workflow_state = 'on_order'
      @reserve.on_order = true
      msg = "Item to be purchased."
    end
    Message.create({'creator'=>additions[0],
      'content'=>msg,
      'request_id'=>@reserve.id})

    @reserve.save!
  end


  def button_title
    if currently_on_order?
      "Item Purchased"
    else
      "Item to be Purchased"
    end
  end


  def button_css
    if currently_on_order?
      "btn btn-warning"
    else
      "btn"
    end
  end


  def update_message
    if currently_on_order?
      "This reserve has been placed on order"
    else
      "This reserve is no longer on order"
    end
  end


  def currently_on_order?
    !!(@reserve.on_order)
  end


  def can_place_on_order?
    @reserve.workflow_state == 'inprocess'
  end

end
