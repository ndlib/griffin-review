class ReserveFairUsePolicy


  def initialize(reserve)
    @reserve = reserve
  end


  def requires_fair_use?
    return true if ['VideoReserve', 'AudioReserve'].include?(@reserve.type)

    policy = ElectronicReservePolicy.new(@reserve)
    return true if policy.has_file_resource? || policy.has_sipx_resource?

    return false
  end


  def complete?
    !requires_fair_use? || @reserve.fair_use.complete?
  end

end
