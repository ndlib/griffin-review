require 'spec_helper'


describe ReserveCanBeViewedPolicy do


  context "no resource attached" do
    before(:each) do
      @policy = ReserveCanBeViewedPolicy.new(double(User), double(Reserve))

      @policy.stub(:resource_completed?).and_return(false)
      @policy.stub(:current_semester?).and_return(false)
      @policy.stub(:user_is_administrator?).and_return(false)
      @policy.stub(:instructor_can_preview?).and_return(false)
    end


    it "returns false even if it is an admin" do
      @policy.stub(:user_is_administrator?).and_return(true)
      expect(@policy.can_be_viewed?).to be_false
    end


    it "return false even if it is in the current semester "  do
      @policy.stub(:current_semester?).and_return(true)
      expect(@policy.can_be_viewed?).to be_false
    end


    it "retuns false even if the semster is next the next and the user instructs it" do
      @policy.stub(:instructor_can_preview?).and_return(true)
      expect(@policy.can_be_viewed?).to be_false
    end
  end


  context "resource attached" do
    before(:each) do
      @policy = ReserveCanBeViewedPolicy.new(double(User), double(Reserve))

      @policy.stub(:resource_completed?).and_return(true)
      @policy.stub(:current_semester?).and_return(false)
      @policy.stub(:user_is_administrator?).and_return(false)
      @policy.stub(:instructor_can_preview?).and_return(false)
    end


    it "returns false if it is not in the current semester or and admin or a previewing instructor" do
      expect(@policy.can_be_viewed?).to be_false
    end


    it "returns true if it is an admin" do
      @policy.stub(:user_is_administrator?).and_return(true)
      expect(@policy.can_be_viewed?).to be_true
    end


    it "return true if it is in the current semester "  do
      @policy.stub(:current_semester?).and_return(true)
      expect(@policy.can_be_viewed?).to be_true
    end


    it "retuns true if the semster is next the next and the user instructs it" do
      @policy.stub(:instructor_can_preview?).and_return(true)
      expect(@policy.can_be_viewed?).to be_true
    end

  end



end
