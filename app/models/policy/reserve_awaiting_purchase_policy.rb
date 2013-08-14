class ReserveAwaitingPurchasePolicy
  attr_accessor :reserve

  def initialize(reserve)
    @reserve = reserve
  end


  def awaiting_purchase?
    @reserve.on_order
  end


  def complete?
    !awaiting_purchase?
  end
end
