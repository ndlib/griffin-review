
describe RequestEditForm do

  before(:each) do
    @reserve = double(Reserve, :id => 1)
  end

  it "passes the reseve id out " do
    aeb = RequestEditForm.new(@reserve)
    aeb.reserve_id.should == 1
  end

  describe :meta_data_complete? do
    it "returns true if the meta data is complete" do
      ReserveMetaDataPolicy.any_instance.stub(:complete?).and_return(true)
      RequestEditForm.new(@reserve).meta_data_complete?.should be_true
    end


    it "returns false if the meta data is not complete" do
      ReserveMetaDataPolicy.any_instance.stub(:complete?).and_return(false)
      RequestEditForm.new(@reserve).meta_data_complete?.should be_false
    end
  end



  describe :complete do

    it "returns true if all the sub parts are true" do
      ReserveCheckIsComplete.any_instance.stub(:complete?).and_return(true)
      RequestEditForm.new(@reserve).complete?.should be_true
    end


    it "returns false if one of the sub parts are not true" do
      ReserveCheckIsComplete.any_instance.stub(:complete?).and_return(false)
      RequestEditForm.new(@reserve).complete?.should be_false
    end
  end
end

