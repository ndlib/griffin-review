
describe ReserveRequiresTermsOfServiceAgreement do


  before(:each) do
    @reserve = double(Reserve)
    ElectronicReservePolicy.any_instance.stub(:has_file_resource?).and_return(false)
    ElectronicReservePolicy.any_instance.stub(:has_streaming_resource?).and_return(false)
    ElectronicReservePolicy.any_instance.stub(:has_media_playlist?).and_return(false)
  end


  it "returns true if the reserve has a file" do
    ElectronicReservePolicy.any_instance.stub(:has_file_resource?).and_return(true)

    expect(ReserveRequiresTermsOfServiceAgreement.new(@reserve).requires_agreement?).to be_truthy
  end


  it "returns true if the reserve has a streaming resource" do
    ElectronicReservePolicy.any_instance.stub(:has_streaming_resource?).and_return(true)

    expect(ReserveRequiresTermsOfServiceAgreement.new(@reserve).requires_agreement?).to be_truthy
  end

  it "returns true if the reserve has a media resource" do
    ElectronicReservePolicy.any_instance.stub(:has_media_playlist?).and_return(true)

    expect(ReserveRequiresTermsOfServiceAgreement.new(@reserve).requires_agreement?).to be_truthy
  end

  it "returns false if it does not have a file or a streaming resource" do
    expect(ReserveRequiresTermsOfServiceAgreement.new(@reserve).requires_agreement?).to be_falsey
  end

end
