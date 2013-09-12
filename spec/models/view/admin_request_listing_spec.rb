require 'spec_helper'

describe AdminReserveList do

  let (:user) { double(User, :username => 'admin')}

  it "gets incomplete listings when the filter is new " do
    ReserveSearch.any_instance.should_receive(:admin_requests).with('new', 'all', 'all')

    arl = AdminReserveList.new(user, {tab: 'new' })
    arl.reserves
  end

  it "gets incomplete listings when the filter is unset" do
    ReserveSearch.any_instance.should_receive(:admin_requests).with('new', 'all', 'all')

    arl = AdminReserveList.new(user, { })
    arl.reserves
  end


  it "gets incomplete listings when the filter is inprocess" do
    ReserveSearch.any_instance.should_receive(:admin_requests).with('inprocess', 'all', 'all')

    arl = AdminReserveList.new(user, {tab: 'inprocess' })
    arl.reserves
  end


  it "gets complete only listings when the filter is complete" do
    ReserveSearch.any_instance.should_receive(:admin_requests).with('available', 'all', 'all')

    arl = AdminReserveList.new(user, {tab: 'available' })
    arl.reserves
  end


  it "gets removed only listings when the filter is removed" do
    ReserveSearch.any_instance.should_receive(:admin_requests).with('available', 'all', 'all')

    arl = AdminReserveList.new(user, {tab: 'available' })
    arl.reserves
  end


  it "returns all the reserves when the filter is all " do
    ReserveSearch.any_instance.should_receive(:admin_requests)

    arl = AdminReserveList.new(user, {tab: 'all' })
    arl.reserves
  end



  it "switches the semester to the one passed in" do
    FactoryGirl.create(:semester)
    s = FactoryGirl.create(:previous_semester)

    arl = AdminReserveList.new(user, { semester_id: s.id})
    arl.semester.id.should == s.id
  end


  it "has a request_tabs" do
    arl = AdminReserveList.new(user, {  })
    arl.respond_to?(:request_tabs)
    arl.request_tabs.class.should == RequestTab
  end

end
