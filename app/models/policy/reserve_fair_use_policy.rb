class ReserveFairUsePolicy


  def initialize(reserve)
    @reserve = reserve
  end


  def requires_fair_use?
    (electronic_reserve_policy.has_file_resource? || electronic_reserve_policy.has_sipx_resource? || electronic_reserve_policy.has_streaming_resource?)
  end


  def complete?
    !requires_fair_use? || @reserve.fair_use.complete?
  end


  private

    def electronic_reserve_policy
      @electronic_reserve_policy ||= ElectronicReservePolicy.new(@reserve)
    end
end
