

describe Rta do


  it "catches an OpenURI::HTTPError and retries the search" do
    # stub the api return with the working result
    rta = Rta.new("000047748", "key")

    # stub the search with the error method and a method to unstub this call so the second call works.
    rta.stub(:search) { rta.unstub(:search); raise OpenURI::HTTPError.new("error"," arg2") }

    rta.should_receive(:search).twice.with("000047748", "key")

    rta.items
  end


  describe :items do
    before(:each) do
      API::PrintReserves.stub(:get).and_return('[{"loan_type":"2 Hour Loan","primary_location":"DVD","secondary_location":"Audio Reserves","current_status":"available","due_date":"","due_time":""}]')
      @rta = Rta.new("000047748", "key")
    end

    it "returns rta holdings objests " do
      expect(@rta.items.first.class).to eq(Rta::RtaHolding)
    end
  end

end
