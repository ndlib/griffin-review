require 'spec_helper'

describe AdminReserveList do

  before(:each) do
    RequestFilter.stub(:new).and_return(double(RequestFilter, library_filters: [ 'library1' ], type_filters: [ 'type'] ))
    @controller = double(ApplicationController, params: { tab: '' })
  end


  it "gets incomplete listings when the filter is new " do
    ReserveSearch.any_instance.should_receive(:admin_requests).with('new', ['type'], [ 'library1' ], false)
    @controller.params[:tab] = 'new'

    arl = AdminReserveList.new(@controller)
    arl.reserves
  end


  it "gets incomplete listings when the filter is unset" do
    ReserveSearch.any_instance.should_receive(:admin_requests).with('new', ['type'], [ 'library1' ], false)
    @controller.stub(:params).and_return({})

    arl = AdminReserveList.new(@controller)
    arl.reserves
  end


  it "gets incomplete listings when the filter is inprocess" do
    ReserveSearch.any_instance.should_receive(:admin_requests).with('inprocess', ['type'], [ 'library1' ], false)
    @controller.params[:tab] = 'inprocess'

    arl = AdminReserveList.new(@controller)
    arl.reserves
  end


  it "gets complete only listings when the filter is complete" do
    ReserveSearch.any_instance.should_receive(:admin_requests).with('available', ['type'], [ 'library1' ], false)
    @controller.params[:tab] = 'available'

    arl = AdminReserveList.new(@controller)
    arl.reserves
  end


  it "gets removed only listings when the filter is removed" do
    ReserveSearch.any_instance.should_receive(:admin_requests).with('available', ['type'], [ 'library1' ], false)
    @controller.params[:tab] = 'available'

    arl = AdminReserveList.new(@controller)
    arl.reserves
  end


  it "returns all the reserves when the filter is all " do
    ReserveSearch.any_instance.should_receive(:admin_requests)
    @controller.params[:tab] = 'all'

    arl = AdminReserveList.new(@controller)
    arl.reserves
  end


  it "switches the semester to the one passed in" do
    FactoryGirl.create(:semester)
    s = FactoryGirl.create(:previous_semester)

    @controller.stub(:params).and_return( { semester_id: s.id })

    arl = AdminReserveList.new(@controller)
    arl.semester.id.should == s.id
  end


  it "has a request_tabs" do
    @controller.stub(:params).and_return({})

    arl = AdminReserveList.new(@controller)
    arl.respond_to?(:request_tabs)
    arl.request_tabs.class.should == RequestTab
  end
end
