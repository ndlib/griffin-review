require 'spec_helper'


describe ReserveMetaDataPolicy do

  describe :complete? do
    before(:each) do
      @reserve = double(Reserve, nd_meta_data_id: nil)
    end

    context :physical_reserve do
      before(:each) do
        @reserve.stub(:physical_reserve?).and_return(true)
      end

      it "returns true if there is an internal meta data id" do
        @reserve.stub(:nd_meta_data_id).and_return("metadataid")

        ReserveMetaDataPolicy.new(@reserve).complete?.should be_true
      end


      it "returns false if the record id has not been set" do
        ReserveMetaDataPolicy.new(@reserve).complete?.should be_false
      end

    end

    context :electronic_reserve do
      before(:each) do
        @reserve.stub(:physical_reserve?).and_return(false)
        @reserve.stub(:request).and_return(double(Request, created_at: Time.now, updated_at: 1.day.from_now))
      end


      it "returns true if the reserve has been reviewed and it is in process" do
        @reserve.request.stub(:updated_at).and_return(4.days.from_now)
        @reserve.stub(:workflow_state).and_return('inprocess')

        ReserveMetaDataPolicy.new(@reserve).complete?.should be_true
      end


      it "returns true if the workflow state is not inprocess" do
        ['available','removed'].each do |state|
          @reserve.stub(:workflow_state).and_return(state)
          ReserveMetaDataPolicy.new(@reserve).complete?.should be_true
        end
      end


      it "returns false if the reserve has not been reviewed and it is not a physical_reserve" do
        @reserve.request.stub(:updated_at).and_return(@reserve.request.created_at)
        @reserve.stub(:workflow_state).and_return('inprocess')

        ReserveMetaDataPolicy.new(@reserve).complete?.should be_false
      end

    end
  end
end
