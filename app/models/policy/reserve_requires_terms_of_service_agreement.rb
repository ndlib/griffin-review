class ReserveRequiresTermsOfServiceAgreement

  def initialize(reserve)
    @reserve = reserve
  end


  def requires_agreement?
    ReserveFairUsePolicy.new(@reserve).requires_fair_use?
  end

end
