class ReserveIsCompletePolicy

  def initialize(reserve)
    @reserve = reserve
  end


  def complete?
    ReserveFairUsePolicy.new(reserve).complete? &&
    ReserveAwaitingPurchasePolicy.new(reserve).complete? &&
    ReserveMetaDataPolicy.new(reserve).complete? &&
    ReserveResourcePolicy.new(reserve).complete?
  end
end
