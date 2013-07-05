require 'spec_helper'


describe ReserveAwaitingPurchasePolicy do

  describe :awaiting_purchase? do
    it "returns true if the reserve is on order" do
      r = mock(Reserve, :on_order=> true)
      ReserveAwaitingPurchasePolicy.new(r).awaiting_purchase?.should be_true
    end


    it "returns false if the reserve is not on_order" do
      r = mock(Reserve, :on_order => false)
      ReserveAwaitingPurchasePolicy.new(r).awaiting_purchase?.should be_false
    end

  end


  describe :complete? do

    it "returns true if it is not awaiting_purchase?" do
      ReserveAwaitingPurchasePolicy.any_instance.stub(:awaiting_purchase?).and_return(true)
      ReserveAwaitingPurchasePolicy.new(mock(Reserve)).complete?.should be_false
    end

    it "returns false if it is awaiting_purchase? " do
      ReserveAwaitingPurchasePolicy.any_instance.stub(:awaiting_purchase?).and_return(false)
      ReserveAwaitingPurchasePolicy.new(mock(Reserve)).complete?.should be_true
    end

  end
end
