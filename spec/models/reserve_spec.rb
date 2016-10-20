  require 'spec_helper'

describe Reserve do

  let(:course_listing) { Reserve.new(request: request) }
  let(:request) { Request.new }
  let(:course_search) { CourseSearch.new }
  let(:semester) { FactoryGirl.create(:semester) }
  let(:course) { double(Course, id: 'crossid', semester: semester) }

  subject { course_listing }


  describe "attribute fields" do

    it "has a title" do
      course_listing.respond_to?(:title).should be_true
    end

    it "has a creator" do
      course_listing.respond_to?(:creator).should be_true
    end

    it "has a contributor" do
      course_listing.respond_to?(:contributor).should be_true
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

    it "has a currently_in_aleph" do
      expect(course_listing.respond_to?(:currently_in_aleph)).to be_true
    end

    it 'delegates sortable_title to request' do
      expect(request).to receive(:sortable_title).and_return('sortable_title')
      expect(subject.sortable_title).to eq('sortable_title')
    end

    it "has a mediaplaylist" do
      expect(course_listing).to respond_to(:media_playlist)
      expect(course_listing).to respond_to(:media_playlist=)
    end

  end



  describe "workflow_state#state_machine" do
    before(:each) do
      @reserve = Reserve.new
    end

    it "starts all reserves in the new state" do
      @reserve.workflow_state.should == "new"
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

    it "can be changed to inprocess from removed" do
      @reserve.remove!
      @reserve.restart!

      expect(@reserve.workflow_state).to eq("inprocess")
    end


    it "destroy the reserve by changing the state" do
      @reserve.title = 'ttile '
      @reserve.type="BookChapter"
      @reserve.requestor_netid = "nid"

      @reserve.course = course

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
      f = FairUse.new(request: r.request, user: User.new(id: 1))
      f.save!

      r.fair_use.id.should == f.id
    end

  end

  describe 'valid reserve' do
    let(:request) { FactoryGirl.create(:request) }
    let(:item) { request.item }
    subject { described_class.factory(request, course)}

    describe '#save!' do
      it 'saves the course id to the request' do
        expect(request.course_id).to_not eq(course.id)
        subject.save!
        expect(request.course_id).to eq(course.id)
      end

      it 'calls copy_item_fields' do
        expect(subject).to receive(:copy_item_fields)
        subject.save!
      end
    end

    describe '#copy_item_fields' do
      it 'copies fields from the item to the' do
        subject.copy_item_fields
        expect(request.item_title).to eq(item.title)
        expect(request.item_selection_title).to eq(item.selection_title)
        expect(request.item_type).to eq(item.type)
        expect(request.item_electronic_reserve).to eq(item.electronic_reserve)
        expect(request.item_physical_reserve).to eq(item.physical_reserve)
        expect(request.item_on_order).to eq(item.on_order)
      end
    end
  end


  describe "presistance" do

    it "addes the course reserve id to the reserve record" do
      request = FactoryGirl.create(:request)
      reserve = Reserve.factory(request, course)
      reserve.save!

      reserve.course_id.should == course.id


    end

    it "raises invalid record if the record is not valid" do
      subject.course = course
      lambda {
        subject.save!
      }.should raise_error(ActiveRecord::RecordInvalid)
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
