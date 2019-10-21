require 'spec_helper'


describe ReserveAwaitingPurchasePolicy do

  describe :awaiting_purchase? do
    it "returns true if the reserve is on order" do
      r = double(Reserve, :on_order=> true)
      ReserveAwaitingPurchasePolicy.new(r).awaiting_purchase?.should be_truthy
    end


    it "returns false if the reserve is not on_order" do
      r = double(Reserve, :on_order => false)
      ReserveAwaitingPurchasePolicy.new(r).awaiting_purchase?.should be_falsey
    end

  end


  describe :complete? do

    it "returns true if it is not awaiting_purchase?" do
      ReserveAwaitingPurchasePolicy.any_instance.stub(:awaiting_purchase?).and_return(true)
      ReserveAwaitingPurchasePolicy.new(double(Reserve)).complete?.should be_falsey
    end

    it "returns false if it is awaiting_purchase? " do
      ReserveAwaitingPurchasePolicy.any_instance.stub(:awaiting_purchase?).and_return(false)
      ReserveAwaitingPurchasePolicy.new(double(Reserve)).complete?.should be_truthy
    end

  end
end
