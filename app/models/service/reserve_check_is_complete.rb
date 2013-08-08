class ReserveCheckIsComplete


  def initialize(reserve, current_user = false)
    @reserve = reserve
    @current_user = current_user
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
    ReserveResourcePolicy.new(@reserve, @current_user).complete?
  end
end
