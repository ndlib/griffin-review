class ReserveCheckIsComplete


  def initialize(reserve)
    @reserve = reserve
  end


  def check!
    if !already_completed? && complete?
      @reserve.complete
      @reserve.save!
    end
  end


  def complete?
    ReserveFairUsePolicy.new(@reserve).complete? &&
    ReserveAwaitingPurchasePolicy.new(@reserve).complete? &&
    ReserveMetaDataPolicy.new(@reserve).complete? &&
    ElectronicReservePolicy.new(@reserve).complete?
  end


  def already_completed?
    @reserve.workflow_state == 'available'
  end

end
