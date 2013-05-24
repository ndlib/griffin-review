require 'spec_helper'

describe ReservesAdminApp do

  before(:each) do
    @reserves_admin = ReservesAdminApp.new('semester', 'current_user')
  end

  describe "#in_complete_reserves" do

    it "only returns reserves that are not complete" do
      @reserves_admin.in_complete_reserves.each do | reserve |
        reserve.workflow_state.should_not == 'complete'
      end
    end


    it "returns reserves that are new"

    it "returns reserves that are awaiting ..."

  end


  describe "#complete_reserves" do

    it "only returns complete reserves " do
      @reserves_admin.completed_reserves.each do | reserve |
        reserve.workflow_state.should == 'complete'
      end
    end
  end


  describe "#reserve" do

    it "decorates reseres with the admin reserve " do
      @reserves_admin.reserve(1).class.should == AdminReserve
    end


    it "searchs for the reserve by id" do
      @reserves_admin.reserve(2).id.should == 2
    end
  end
end
