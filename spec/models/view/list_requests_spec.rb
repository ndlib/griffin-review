require 'spec_helper'

describe ListRequests do

  before(:each) do
    @request_filter = double(RequestFilter, library_filters: [ 'library1' ], type_filters: [ 'type'], semester_filter: false )

    @new_tab = double(RequestTab, filter: 'new')
    @inprocess_tab = double(RequestTab, filter: 'inprocess')
    @available_tab = double(RequestTab, filter: 'available')
    @all_tab = double(RequestTab, filter: 'all')
  end

  describe :build_from_params do
    before(:each) do
      @controller = double(ApplicationController, session: {}, params: { }, current_user: double(User, username: 'jhartzle', admin_preferences: nil, ))
    end

    it "creates a valid object" do
      expect(ListRequests.build_from_params(@controller).class).to eq(ListRequests)
    end

    it "builds the request tabs from empty params" do
      @controller.params[:tab] = 'new'
      list = ListRequests.build_from_params(@controller)
      expect(list.request_tabs.filter).to eq("new")
    end

    it "builds the request tabs from a passed in params" do
      @controller.params[:tab] = 'inprocess'
      list = ListRequests.build_from_params(@controller)
      expect(list.request_tabs.filter).to eq("inprocess")
    end

    it "builds the request filter from params" do

    end
  end


  it "gets incomplete listings when the filter is new " do
    ReserveSearch.any_instance.should_receive(:admin_requests).with(false)
    ListRequests.new(@new_tab, @request_filter).reserves
  end


  it "gets incomplete listings when the filter is inprocess" do
    ReserveSearch.any_instance.should_receive(:admin_requests).with(false)
    ListRequests.new(@inprocess_tab, @request_filter).reserves
  end


  it "gets complete only listings when the filter is complete" do
    ReserveSearch.any_instance.should_receive(:admin_requests).with(false)
    ListRequests.new(@available_tab, @request_filter).reserves
  end


  it "gets removed only listings when the filter is removed" do
    ReserveSearch.any_instance.should_receive(:admin_requests).with(false)
    ListRequests.new(@available_tab, @request_filter).reserves
  end


  it "returns all the reserves when the filter is all " do
    ReserveSearch.any_instance.should_receive(:admin_requests)
    ListRequests.new(@all_tab, @request_filter).reserves
  end


  it "switches the semester to the one passed in" do
    s = FactoryGirl.create(:previous_semester)

    filter = double(RequestFilter, library_filters: [ 'library1' ], type_filters: [ 'type'], semester_filter: s.id )
    ReserveSearch.any_instance.should_receive(:admin_requests).with(s)

    @controller.stub(:params).and_return( {  })

    ListRequests.new(@new_tab, filter).reserves
  end


  it "has a request_tabs" do
    @controller.stub(:params).and_return({})

    list = ListRequests.new(@new_tab, @request_filter)

    list.respond_to?(:request_tabs)
    expect(list.request_tabs).to eq(@new_tab)
  end
end
