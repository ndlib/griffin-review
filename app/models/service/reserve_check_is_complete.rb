class ReserveCheckIsComplete


  def initialize(reserve)
    @reserve = reserve
  end


  def check!
    if @reserve.inprocess? && complete?
      @reserve.complete
      @reserve.save!
    end
  end


  def complete?
    ReserveFairUsePolicy.new(@reserve).complete? &&
    ReserveAwaitingPurchasePolicy.new(@reserve).complete? &&
    ReserveMetaDataPolicy.new(@reserve).complete? &&
    ReserveResourcePolicy.new(@reserve).complete?
  end
end
