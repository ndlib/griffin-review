class ReserveFairUsePolicy


  def initialize(reserve)
    @reserve = reserve
  end


  def requires_fair_use?
    return true if ['VideoReserve', 'AudioReserve'].include?(@reserve.type)

    return true if electronic_reserve_policy.has_file_resource? || electronic_reserve_policy.has_sipx_resource?

    return false
  end


  def complete?
    !requires_fair_use? || @reserve.fair_use.complete?
  end


  private

    def electronic_reserve_policy
      @electronic_reserve_policy ||= ElectronicReservePolicy.new(@reserve)
    end
end
