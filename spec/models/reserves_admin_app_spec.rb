require 'spec_helper'

describe ReservesAdminApp do

  before(:each) do
    FactoryGirl.create(:semester)
    @reserves_admin = ReservesAdminApp.new(mock(User))
  end

  describe "#in_complete_reserves" do

    before(:each) do
      mock_reserve FactoryGirl.create(:request, :available), mock(Course, id: 'id', crosslist_id: 'crosslist_id')
      mock_reserve FactoryGirl.create(:request, :new), mock(Course, id: 'id', crosslist_id: 'crosslist_id')
      mock_reserve FactoryGirl.create(:request, :inprocess), mock(Course, id: 'id', crosslist_id: 'crosslist_id')
    end

    it "only returns reserves that are not complete" do
      @reserves_admin.in_complete_reserves.each do | reserve |
        reserve.workflow_state.should_not == 'available'
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
      reserve = mock_reserve FactoryGirl.create(:request, :inprocess), mock(Course, id: 'id', crosslist_id: 'crosslist_id')

      @reserves_admin.reserve(reserve.id).class.should == AdminReserve
    end


    it "searchs for the reserve by id" do
      reserve = mock_reserve FactoryGirl.create(:request, :inprocess), mock(Course, id: 'id', crosslist_id: 'crosslist_id')

      @reserves_admin.reserve(reserve.id).id.should == reserve.id
    end
  end
end
