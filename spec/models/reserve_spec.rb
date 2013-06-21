  require 'spec_helper'

describe Reserve do

  let(:course_listing) { Reserve.new() }
  let(:course_search) { CourseSearch.new }

  before(:each) do
    stub_courses!
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


    describe :tags do

      it "has tags" do
        course_listing.respond_to?(:tags).should be_true
      end
    end


    describe :discovery do

      describe :title do

        it "returns the title from the discovery api if the record is connected." do
          VCR.use_cassette 'discovery/book' do
            course_listing = Reserve.new(nd_meta_data_id: "book", title: "not real title")
            course_listing.title.should == "Book."
          end

        end


        it "returns title stored in the request if there is no nd_meta_data_id" do
          course_listing = Reserve.new( title: "title")

          course_listing.title.should == "title"
        end
      end


      describe :creator_contributor do

        it "returns the creator_contributor from the discovery api if the record is connected" do
          VCR.use_cassette 'discovery/book' do
            course_listing = Reserve.new(nd_meta_data_id: "book", creator: "not creator")
            course_listing.creator_contributor.should == "Ronnie Wathen 1934-."
          end
        end


        it "returns the author in the request if there is no discovery id" do
          course_listing = Reserve.new( creator: "creator")

          course_listing.creator_contributor.should == "creator"
        end

      end


      describe :publisher_provider do

        it "returns the publisher_provider from the discovery api if the record is connected" do
          VCR.use_cassette 'discovery/book' do
            course_listing = Reserve.new(nd_meta_data_id: "book", journal_title: "title")
            course_listing.publisher_provider.should == "s.l. : s.n. 1968"
          end
        end


        it "returns the author in the request if there is no discovery id" do
          course_listing = Reserve.new( journal_title: "title")

          course_listing.publisher_provider.should == "title"
        end

      end


      describe :availability do

        it "returns the availability from the discovery api if the record is connected" do
          VCR.use_cassette 'discovery/book' do
            course_listing = Reserve.new(nd_meta_data_id: "book")
            course_listing.availability.should == "Available"
          end
        end


        it "returns the author in the request if there is no discovery id" do
          course_listing = Reserve.new( )

          course_listing.availability.should == ""
        end

      end


      describe :available_library do

        it "returns the available_library from the discovery api if the record is connected" do
          VCR.use_cassette 'discovery/book' do
            course_listing = Reserve.new(nd_meta_data_id: "book")
            course_listing.available_library.should == "Notre Dame, Hesburgh Library General Collection (PR 6073 .A83 B6 )"
          end
        end


        it "returns the author in the request if there is no discovery id" do
          course_listing = Reserve.new( )

          course_listing.available_library.should == ""
        end

      end

    end

    describe :discovery_api do

      it "returns builds a discvo"
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
  end


  describe "presistance" do
    before(:each) do
      @reserve = Reserve.new
    end

    it "addes the course reserve id to the reserve record" do
      request = FactoryGirl.create(:request)
      course = course_search.get( 'current_multisection_crosslisted')
      reserve = Reserve.factory(request, course)
      reserve.save!

      reserve.course_id.should == course.id


    end

    it "raises invalid record if the record is not valid" do
      @reserve.course = course_search.get('current_multisection_crosslisted')
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
end
