  require 'spec_helper'

describe Reserve do

  let(:course_listing) { Reserve.new() }
  let(:course_search) { CourseSearch.new }

  before(:each) do
    @semester = FactoryGirl.create(:semester)
    @course = double(Course, id: 'crossid', semester: @semester)
  end

  describe "attribute fields" do

    it "has a title" do
      course_listing.respond_to?(:title).should be_true
    end


    it "has a creator" do
      course_listing.respond_to?(:creator).should be_true
    end


    it "has a journal title" do
      course_listing.respond_to?(:journal_title).should be_true
    end


    it "has a length" do
      course_listing.respond_to?(:length).should be_true
    end


    it "has a pdf" do
      course_listing.respond_to?(:pdf).should be_true
    end


    it "has a url" do
      course_listing.respond_to?(:url).should be_true
    end


    it "has note" do
      course_listing.respond_to?(:note).should be_true
    end


    it "has a css class for the record display" do
      course_listing.respond_to?(:css_class)
    end


    it "has a physical reserve flag" do
      expect(course_listing.respond_to?(:physical_reserve)).to be_true
    end

  end



  describe "workflow_state#state_machine" do
    before(:each) do
      @reserve = Reserve.new
    end

    it "starts all reserves in the new state" do
      @reserve.workflow_state.should == "new"
    end


    it "can be placed on order" do
      @reserve.start!
      @reserve.order!

      expect(@reserve.workflow_state).to eq("on_order")
    end

    it "can be completed" do
      @reserve.complete!
      @reserve.workflow_state.should == "available"
    end


    it "can be started" do
      @reserve.start!
      @reserve.workflow_state.should == "inprocess"
    end


    it "can be restarted" do
      @reserve.complete!
      @reserve.restart!
      @reserve.workflow_state.should == "inprocess"
    end


    it "can be completed from inprocess" do
      @reserve.start!
      @reserve.complete!
      @reserve.workflow_state.should == "available"
    end


    it "can be completed from on order" do
      @reserve.workflow_state = 'on_order'

      @reserve.complete!
      @reserve.workflow_state.should == "available"
    end


    it "can be removed from the new state" do
      @reserve.remove!
      @reserve.workflow_state.should == "removed"
    end


    it "can be removed from the inprocess state" do
      @reserve.start!
      @reserve.remove!
      @reserve.workflow_state.should == "removed"
    end


    it "can be removed from the available state" do
      @reserve.complete!
      @reserve.remove!
      @reserve.workflow_state.should == "removed"
    end


    it "destroy the reserve by changing the state" do
      @reserve.title = 'ttile '
      @reserve.type="BookChapter"
      @reserve.requestor_netid = "nid"

      @reserve.course = @course

      @reserve.save!

      @reserve.destroy!
      @reserve.workflow_state.should == "removed"
    end
  end


  describe :title do

    before(:each) do
      @reserve = Reserve.new
      @reserve.display_length= "Part1"
      @reserve.title = "title"
    end

    it "includes the display_length in the title if the meta data is synchronizated " do
      @reserve.stub(:overwrite_nd_meta_data?).and_return(false)

      expect(@reserve.title).to eq("title - Part1")
    end

    it "does not include the display_length if the meta data is overwritten." do
      @reserve.stub(:overwrite_nd_meta_data?).and_return(true)

      expect(@reserve.title).to eq("title")
    end

    it "does not include the display_length if there is none" do
      @reserve.stub(:overwrite_nd_meta_data?).and_return(false)
      @reserve.display_length= ""

      expect(@reserve.title).to eq("title")
    end
  end

  describe :fair_use do

    it "creates an empty fair use object when there isn't one " do
      r = mock_reserve FactoryGirl.create(:request), nil
      r.fair_use.new_record?.should be_true
    end

    it "returns the current fair use if there is one associated with the reserve" do
      r = mock_reserve FactoryGirl.create(:request), nil
      f = FairUse.new(request: r.request, user: mock_model(User, id: 1))
      f.save!

      r.fair_use.id.should == f.id
    end

  end


  describe "presistance" do
    before(:each) do
      @reserve = Reserve.new
    end

    it "addes the course reserve id to the reserve record" do
      request = FactoryGirl.create(:request)
      course = @course
      reserve = Reserve.factory(request, course)
      reserve.save!

      reserve.course_id.should == course.id


    end

    it "raises invalid record if the record is not valid" do
      @reserve.course = @course
      lambda {
        @reserve.save!
      }.should raise_error
    end


  end


  describe "new" do
    it "can take the database request object to decorate" do
      req = FactoryGirl.create(:request)
      reserve = Reserve.new(request: req)

      reserve.requestor_netid.should == req.requestor_netid
    end
  end


  describe "versioning" do

    it "uses some sort of versionsing to keep track of history."

  end
end
