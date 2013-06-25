
describe AdminEditButton do

  before(:each) do
    @reserve = mock(Reserve, :id => 1)
  end

  it "passes the reseve id out " do
    aeb = AdminEditButton.new(@reserve)
    aeb.reserve_id.should == 1
  end

  describe :meta_data_complete? do
    it "returns true if the meta data is complete" do
      ReserveMetaDataPolicy.any_instance.stub(:has_meta_data?).and_return(true)
      AdminEditButton.new(@reserve).meta_data_complete?.should be_true
    end


    it "returns false if the meta data is not complete" do
      ReserveMetaDataPolicy.any_instance.stub(:has_meta_data?).and_return(false)
      AdminEditButton.new(@reserve).meta_data_complete?.should be_false
    end
  end


  describe :meta_data_css_class do

    it "returns the correct class if the meta_data is complete" do
      AdminEditButton.any_instance.stub(:meta_data_complete?).and_return(true)
      AdminEditButton.new(@reserve).meta_data_css_class.should == 'icon-ok'
    end


    it "returns the correct class if the meta data is not complete" do
      AdminEditButton.any_instance.stub(:meta_data_complete?).and_return(false)
      AdminEditButton.new(@reserve).meta_data_css_class.should == ''
    end
  end


  describe :complete do

    it "returns true if all the sub parts are true" do
      AdminEditButton.any_instance.stub(:meta_data_complete?).and_return(true)
      AdminEditButton.any_instance.stub(:external_resouce_comeplete?).and_return(true)
      AdminEditButton.any_instance.stub(:fair_use_complete?).and_return(true)

      AdminEditButton.new(@reserve).complete?.should be_true
    end


    it "returns false if one of the sub parts are not true" do
      AdminEditButton.any_instance.stub(:meta_data_complete?).and_return(false)
      AdminEditButton.any_instance.stub(:external_resouce_comeplete?).and_return(true)
      AdminEditButton.any_instance.stub(:fair_use_complete?).and_return(true)

      AdminEditButton.new(@reserve).complete?.should be_false
    end
  end
end

