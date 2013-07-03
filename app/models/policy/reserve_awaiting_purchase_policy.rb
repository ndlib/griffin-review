class ReserveAwaitingPurchasePolicy


  def initialize(reserve)
    @reserve = reserve
  end


  def awaiting_puchase?
    false
  end


  def complete?
    !awaiting_puchase?
  end
end
