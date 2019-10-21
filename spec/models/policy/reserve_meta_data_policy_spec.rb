require 'spec_helper'


describe ReserveMetaDataPolicy do

  describe :complete? do
    context :physical_reserve do

      let(:reserve) { double(Reserve, nd_meta_data_id: nil, physical_reserve?: true )}

      subject { described_class.new(reserve)}

      it "returns true if there is an internal meta data id and it is in aleph" do
        reserve.stub(:nd_meta_data_id).and_return("metadataid")
        subject.stub(:reserve_in_aleph?).and_return(true)

        subject.complete?.should be_truthy
      end


      it "returns false if the record id has not been set" do
        subject.stub(:reserve_in_aleph?).and_return(true)

        subject.complete?.should be_falsey
      end

      it "returns false if it is not currently in aleph " do
        @reserve.stub(:nd_meta_data_id).and_return("metadataid")
        subject.complete?.should be_falsey
      end

    end

    context :electronic_reserve do
      let(:reserve) { double(Reserve,  physical_reserve?: false, request: double(Request, created_at: Time.now, updated_at: 1.day.from_now))}

      subject { described_class.new(reserve)}



      it "returns true if the reserve has been reviewed and it is in process" do
        reserve.stub(:reviewed?).and_return(true)
        reserve.stub(:workflow_state).and_return('inprocess')

        subject.complete?.should be_truthy
      end


      it "returns false if the reserve has not been reviewed and it is not a physical_reserve" do
        reserve.stub(:reviewed?).and_return(false)

        subject.complete?.should be_falsey
      end

    end
  end
end
