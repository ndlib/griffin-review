require "spec_helper"

describe ReserveCheckIsComplete do

  before(:each) do
    FactoryBot.create(:semester)
  end

  describe :check! do

    it "updates the reserve status to complete if all the data is complete" do
      reserve = mock_reserve(FactoryBot.create(:request, :inprocess), double(Course, id: 'course_id', crosslist_id: 'crosslist_id', semester: Semester.first))
      rcic = ReserveCheckIsComplete.new(reserve)
      rcic.stub(:complete?).and_return(true)

      rcic.check!
      reserve.request.reload()
      reserve.workflow_state.should == "available"
    end

    it "leaves the state where it is if the data is not complete" do
      reserve = mock_reserve(FactoryBot.create(:request, :inprocess), nil)
      rcic = ReserveCheckIsComplete.new(reserve)
      rcic.stub(:complete?).and_return(false)

      rcic.check!
      reserve.request.reload()
      reserve.workflow_state.should == "inprocess"
    end

    context :already_complete do
      before(:each) do
        @reserve = double(Reserve)
        @policy = ReserveCheckIsComplete.new(@reserve)
        @policy.stub(:already_completed?).and_return(true)
      end


      it "restarts a reserve if is no longer complete" do
        @policy.stub(:complete?).and_return(false)

        @reserve.should_receive(:restart)
        @reserve.should_receive(:save!)

        @policy.check!
      end

      it "does not restart the the reserve if the item is still complete" do
        @policy.stub(:complete?).and_return(true)

        @reserve.should_not_receive(:restart)

        @policy.check!

      end
    end
  end


  describe :compete? do

    it "returns true if all the sub parts have been updated." do

      ReserveFairUsePolicy.any_instance.stub(:complete?).and_return(true)
      ReserveAwaitingPurchasePolicy.any_instance.stub(:complete?).and_return(true)
      ReserveMetaDataPolicy.any_instance.stub(:complete?).and_return(true)
      ElectronicReservePolicy.any_instance.stub(:complete?).and_return(true)

      ReserveCheckIsComplete.new(double(Reserve)).complete?.should be_truthy
    end


    it "returns false if the fair use is false " do

      ReserveFairUsePolicy.any_instance.stub(:complete?).and_return(false)
      ReserveAwaitingPurchasePolicy.any_instance.stub(:complete?).and_return(true)
      ReserveMetaDataPolicy.any_instance.stub(:complete?).and_return(true)
      ElectronicReservePolicy.any_instance.stub(:complete?).and_return(true)

      ReserveCheckIsComplete.new(double(Reserve)).complete?.should be_falsey
    end


    it "returns false if the awaiting purchase is false " do

      ReserveFairUsePolicy.any_instance.stub(:complete?).and_return(true)
      ReserveAwaitingPurchasePolicy.any_instance.stub(:complete?).and_return(false)
      ReserveMetaDataPolicy.any_instance.stub(:complete?).and_return(true)
      ElectronicReservePolicy.any_instance.stub(:complete?).and_return(true)

      ReserveCheckIsComplete.new(double(Reserve)).complete?.should be_falsey
    end


    it "returns false if the meta data is false " do

      ReserveFairUsePolicy.any_instance.stub(:complete?).and_return(true)
      ReserveAwaitingPurchasePolicy.any_instance.stub(:complete?).and_return(true)
      ReserveMetaDataPolicy.any_instance.stub(:complete?).and_return(false)
      ElectronicReservePolicy.any_instance.stub(:complete?).and_return(true)

      ReserveCheckIsComplete.new(double(Reserve)).complete?.should be_falsey
    end


    it "returns false if the ElectronicReservePolicy is false " do

      ReserveFairUsePolicy.any_instance.stub(:complete?).and_return(true)
      ReserveAwaitingPurchasePolicy.any_instance.stub(:complete?).and_return(true)
      ReserveMetaDataPolicy.any_instance.stub(:complete?).and_return(true)
      ElectronicReservePolicy.any_instance.stub(:complete?).and_return(false)

      ReserveCheckIsComplete.new(double(Reserve)).complete?.should be_falsey
    end
  end
end
