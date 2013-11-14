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
      end


      it "returns true if the reserve has been reviewed and it is not a physical_reserve" do

      end


      it "returns false if the reserve has not been reviewed and it is not a physical_reserve" do

      end

    end
  end
end
