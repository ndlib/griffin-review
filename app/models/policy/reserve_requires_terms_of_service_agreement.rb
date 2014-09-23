class ReserveRequiresTermsOfServiceAgreement

  def initialize(reserve)
    @reserve = reserve
  end


  def requires_agreement?
    policy = ElectronicReservePolicy.new(@reserve)
    policy.has_file_resource? || policy.has_streaming_resource? || policy.has_media_playlist?
  end

end
