require "spec_helper"

describe ReserveIsCompletePolicy

  describe :compete? do

    it "returns true if all the sub parts have been updated." do

      ReserveFairUsePolicy.any_instance.stub(:complete?).and_return(true)
      ReserveAwaitingPurchasePolicy.any_instance.stub(:complete?).and_return(true)
      ReserveMetaDataPolicy.any_instance.stub(:complete?).and_return(true)
      ReserveResourcePolicy.any_instance.stub(:complete?).and_return(true)

      ReserveIsCompletePolicy.new(mock(Reserve)).complete?.should be_true
    end


    it "returns false if the fair use is false " do

      ReserveFairUsePolicy.any_instance.stub(:complete?).and_return(false)
      ReserveAwaitingPurchasePolicy.any_instance.stub(:complete?).and_return(true)
      ReserveMetaDataPolicy.any_instance.stub(:complete?).and_return(true)
      ReserveResourcePolicy.any_instance.stub(:complete?).and_return(true)

      ReserveIsCompletePolicy.new(mock(Reserve)).complete?.should be_false
    end


    it "returns false if the awaiting purchase is false " do

      ReserveFairUsePolicy.any_instance.stub(:complete?).and_return(true)
      ReserveAwaitingPurchasePolicy.any_instance.stub(:complete?).and_return(false)
      ReserveMetaDataPolicy.any_instance.stub(:complete?).and_return(true)
      ReserveResourcePolicy.any_instance.stub(:complete?).and_return(true)

      ReserveIsCompletePolicy.new(mock(Reserve)).complete?.should be_false
    end


    it "returns false if the meta data is false " do

      ReserveFairUsePolicy.any_instance.stub(:complete?).and_return(true)
      ReserveAwaitingPurchasePolicy.any_instance.stub(:complete?).and_return(true)
      ReserveMetaDataPolicy.any_instance.stub(:complete?).and_return(false)
      ReserveResourcePolicy.any_instance.stub(:complete?).and_return(true)

      ReserveIsCompletePolicy.new(mock(Reserve)).complete?.should be_false
    end


    it "returns false if the ReserveResourcePolicy is false " do

      ReserveFairUsePolicy.any_instance.stub(:complete?).and_return(true)
      ReserveAwaitingPurchasePolicy.any_instance.stub(:complete?).and_return(true)
      ReserveMetaDataPolicy.any_instance.stub(:complete?).and_return(true)
      ReserveResourcePolicy.any_instance.stub(:complete?).and_return(false)

      ReserveIsCompletePolicy.new(mock(Reserve)).complete?.should be_false
    end

end
