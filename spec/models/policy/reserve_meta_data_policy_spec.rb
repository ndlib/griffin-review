require 'spec_helper'


describe ReserveIsEditablePolicy do

  describe :complete? do
    before(:each) do
      @reserve = double(Reserve, nd_meta_data_id: nil, overwrite_nd_meta_data?: false)
    end


    it "returns true if there is an internal meta data id" do
      @reserve.stub(:nd_meta_data_id).and_return("metadataid")

      ReserveMetaDataPolicy.new(@reserve).complete?.should be_true
    end

    it "returns true if the meta data has been overwritten"  do
      @reserve.stub(:overwrite_nd_meta_data?).and_return(true)

      ReserveMetaDataPolicy.new(@reserve).complete?.should be_true
    end


    it "returns false if the metadata has not been overwritten and there is no internal meta data" do
      ReserveMetaDataPolicy.new(@reserve).complete?.should be_false
    end

  end

end
