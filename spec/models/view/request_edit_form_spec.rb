
describe RequestEditForm do

  before(:each) do
    @reserve = double(Reserve, id: 1, course: double(Course, id: 1))
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


  describe :delete_link do

    it "returns a link to delete the reserve from the course and return to this page " do
      aeb = RequestEditForm.new(@reserve)
      expect(aeb.delete_link).to eq("<a class=\"btn text-error\" data-confirm=\"Are you sure you wish to remove this reserve from this semester?\" data-method=\"delete\" href=\"/courses/1/reserves/1?redirect_to=admin\" id=\"delete_reserve_1\" rel=\"nofollow\"><i class=\"icon-remove\"></i> Delete Reserve</a>")
    end
  end
end

