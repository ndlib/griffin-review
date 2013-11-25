require "spec_helper"

describe ReserveCheckIsComplete do

  before(:each) do
    FactoryGirl.create(:semester)
  end

  describe :check! do

    it "updates the reserve status to complete if all the data is complete" do
      reserve = mock_reserve(FactoryGirl.create(:request, :inprocess), double(Course, id: 'course_id', crosslist_id: 'crosslist_id', semester: Semester.first))
      rcic = ReserveCheckIsComplete.new(reserve)
      rcic.stub(:complete?).and_return(true)

      rcic.check!
      reserve.request.reload()
      reserve.workflow_state.should == "available"
    end

    it "leaves the state where it is if the data is not complete" do
      reserve = mock_reserve(FactoryGirl.create(:request, :inprocess), nil)
      rcic = ReserveCheckIsComplete.new(reserve)
      rcic.stub(:complete?).and_return(false)

      rcic.check!
      reserve.request.reload()
      reserve.workflow_state.should == "inprocess"
    end
  end


  describe :compete? do

    it "returns true if all the sub parts have been updated." do

      ReserveFairUsePolicy.any_instance.stub(:complete?).and_return(true)
      ReserveAwaitingPurchasePolicy.any_instance.stub(:complete?).and_return(true)
      ReserveMetaDataPolicy.any_instance.stub(:complete?).and_return(true)
      ElectronicReservePolicy.any_instance.stub(:complete?).and_return(true)

      ReserveCheckIsComplete.new(double(Reserve)).complete?.should be_true
    end


    it "returns false if the fair use is false " do

      ReserveFairUsePolicy.any_instance.stub(:complete?).and_return(false)
      ReserveAwaitingPurchasePolicy.any_instance.stub(:complete?).and_return(true)
      ReserveMetaDataPolicy.any_instance.stub(:complete?).and_return(true)
      ElectronicReservePolicy.any_instance.stub(:complete?).and_return(true)

      ReserveCheckIsComplete.new(double(Reserve)).complete?.should be_false
    end


    it "returns false if the awaiting purchase is false " do

      ReserveFairUsePolicy.any_instance.stub(:complete?).and_return(true)
      ReserveAwaitingPurchasePolicy.any_instance.stub(:complete?).and_return(false)
      ReserveMetaDataPolicy.any_instance.stub(:complete?).and_return(true)
      ElectronicReservePolicy.any_instance.stub(:complete?).and_return(true)

      ReserveCheckIsComplete.new(double(Reserve)).complete?.should be_false
    end


    it "returns false if the meta data is false " do

      ReserveFairUsePolicy.any_instance.stub(:complete?).and_return(true)
      ReserveAwaitingPurchasePolicy.any_instance.stub(:complete?).and_return(true)
      ReserveMetaDataPolicy.any_instance.stub(:complete?).and_return(false)
      ElectronicReservePolicy.any_instance.stub(:complete?).and_return(true)

      ReserveCheckIsComplete.new(double(Reserve)).complete?.should be_false
    end


    it "returns false if the ElectronicReservePolicy is false " do

      ReserveFairUsePolicy.any_instance.stub(:complete?).and_return(true)
      ReserveAwaitingPurchasePolicy.any_instance.stub(:complete?).and_return(true)
      ReserveMetaDataPolicy.any_instance.stub(:complete?).and_return(true)
      ElectronicReservePolicy.any_instance.stub(:complete?).and_return(false)

      ReserveCheckIsComplete.new(double(Reserve)).complete?.should be_false
    end
  end
end
