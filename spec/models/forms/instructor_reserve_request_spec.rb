require 'spec_helper'
Reserve

describe InstructorReserveRequest do

  let(:user) { double(User, :username => 'instructor') }
  let(:semester) { FactoryGirl.create(:semester)}


  before(:each) do

    @course = double(Course, :id => "course_id", :title => 'title', :primary_instructor => double(User, display_name: 'name'), :crosslist_id => 'crosslist_id', :full_title => 'full_title')
    @course.stub(:semester).and_return(semester)
    @course.stub(:reserve_id).and_return('reserve_id')

    basic_params = { :course_id => @course.id }

    @controller = double(current_user: user, params: basic_params, add_flash: true )

    InstructorReserveRequest.any_instance.stub(:get_course).with("course_id").and_return(@course)
    @instructor_reserve = InstructorReserveRequest.new(@controller)
  end


  it "has the current user associated with it" do
    @instructor_reserve.current_user.should == user
  end


  describe "attributes" do

    it "has all the form attributes" do
      [
        :title, :publisher, :journal_title, :creator, :length, :note, :needed_by, :type, :pdf,
        :requestor_owns_a_copy, :requestor_has_an_electronic_copy, :library, :number_of_copies, :citation, :physical_reserve
      ].each do | at |
        @instructor_reserve.respond_to?(at).should be_truthy
      end
    end
  end


  describe "validation" do

    describe "all types" do
      it "requires a title" do
        @instructor_reserve.should have(1).error_on(:title)
      end


      it "requires a needed_by" do
        @instructor_reserve.should have(1).error_on(:needed_by)
      end


      it "requires needed by to be 3 weeks out" do
        @instructor_reserve.needed_by = 22.days.from_now
        @instructor_reserve.should have(0).error_on(:needed_by)
      end


      it "requires a library" do
        @instructor_reserve.should have(1).error_on(:library)
      end


      it "requires a resource_format" do
        @instructor_reserve.should have(2).error_on(:resource_format)
      end

    end


    describe "creator" do

    end


    describe "length" do

      it "requires the lenght field if the type is BookChapter" do
        @instructor_reserve.type = 'BookChapterReserve'
        @instructor_reserve.should have(1).error_on(:length)
      end


      it "does not require the length for types: Book, Journal, Audio, Video" do
        ['BookReserve', 'VideoReserve', 'JournalReserve', 'AudioReserve'].each do | type |
          @instructor_reserve.type = type
          @instructor_reserve.should_not have(1).error_on(:length)
        end
      end
    end


    describe "journal_title" do

    end


    describe "citation" do
      it "does not require the citation is video or audioo" do
        ['VideoReserve', 'AudioReserve'].each do | type |
          @instructor_reserve.type = type
          @instructor_reserve.should_not have(1).error_on(:citation)
        end
      end


      it "does not require the length for types: Book, Journal, Audio, Video" do
        ['BookReserve', 'JournalReserve', 'BookChapterReserve'].each do | type |
          @instructor_reserve.type = type
          @instructor_reserve.should have(1).error_on(:citation)
        end
      end
    end


    describe "type" do

      it "allows each of the types Book, BookChapter, Audio, Video Journal" do
        ['BookReserve', 'VideoReserve', 'BookChapterReserve', 'AudioReserve', 'JournalReserve'].each do | type |
          @instructor_reserve.type = type
          @instructor_reserve.should_not have(1).error_on(:type)
        end
      end


      it "does not allow nil" do
        @instructor_reserve.should have(1).error_on(:type)
      end


      it "does not allow types that are not in the accepted values" do
        ['adsfaf', '@#$@#', 'hgsfgfddg'].each do | type |
          @instructor_reserve.type = type
          @instructor_reserve.should have(1).error_on(:type)
        end
      end
    end
  end


  describe :save_attributes do
    it "removes the resource_format form the attributes" do
      @controller.stub(:params).and_return ({ :course_id => @course.id, :instructor_reserve_request => {'resource_format' => 'both', 'title' => "title", type: "BookReserve", citation: "creator", needed_by: 22.days.from_now, library: "Hesburgh" }} )

      @instructor_reserve = InstructorReserveRequest.new(@controller)
      expect(@instructor_reserve.send(:save_attributes)[:resource_format]).to be_nil
    end
  end


  describe "make_request" do

    it "creates the reserve with valid params" do
      @controller.stub(:params).and_return ({ :course_id => @course.id, :instructor_reserve_request => {'title' => "title", resource_format: 'both', type: "BookReserve", citation: "creator", needed_by: 22.days.from_now, library: "Hesburgh" }} )

      @instructor_reserve = InstructorReserveRequest.new(@controller)
      @instructor_reserve.make_request.should be_truthy
    end


    it "does not create a reserve when there are not valid params" do
      @controller.stub(:params).and_return ({ :course_id => @course.id, :instructor_reserve_request => {'title' => "title", type: "BookReserve" } })

      @instructor_reserve = InstructorReserveRequest.new(@controller)
      @instructor_reserve.make_request.should be_falsey
    end


    it "starts the reserve out in the new workflow_state" do
      @controller.stub(:params).and_return ({ :course_id => @course.id, :instructor_reserve_request => {'title' => "title", type: "BookReserve", creator: "creator", needed_by: Time.now, library: "Hesburgh" } })

      @instructor_reserve = InstructorReserveRequest.new(@controller)
      @instructor_reserve.make_request

      @instructor_reserve.reserve.workflow_state == "new"
    end


    it "adds a flash message on success " do
      @controller.stub(:params).and_return ({ :course_id => @course.id, :instructor_reserve_request => {'title' => "title", resource_format: 'both', type: "BookReserve", citation: "creator", needed_by: 22.days.from_now, library: "Hesburgh" }} )
      @instructor_reserve = InstructorReserveRequest.new(@controller)

      expect(@controller).to receive(:add_flash).with(:success, "<h4>New Request Made</h4><p> Your request has been received and will be processed as soon as possible.  </p><a href=\"/courses/course_id/reserves\" class=\"btn btn-primary\">I am Done</a>")
      @instructor_reserve.make_request
    end


    it "adds a flahs message on failure" do
      @controller.stub(:params).and_return ({ :course_id => @course.id, :instructor_reserve_request => {'title' => "title", type: "BookReserve" } })

      @instructor_reserve = InstructorReserveRequest.new(@controller)

      expect(@controller).to receive(:add_flash).with(:error, "Your form submission has errors in it.  Please correct them and resubmit.", true)
      @instructor_reserve.make_request
    end


    it "resource_format of electronic sets the reserve to be electronic" do
      @controller.stub(:params).and_return ({ :course_id => @course.id, :instructor_reserve_request => {'title' => "title", resource_format: 'electronic', type: "BookReserve", citation: "creator", needed_by: 22.days.from_now, library: "Hesburgh" }} )
      @instructor_reserve = InstructorReserveRequest.new(@controller)
      @instructor_reserve.make_request

      expect(@instructor_reserve.reserve.electronic_reserve).to be_truthy
      expect(@instructor_reserve.reserve.physical_reserve).to be_falsey
    end


    it "resource_format of both sets both electronic and physical" do
      @controller.stub(:params).and_return ({ :course_id => @course.id, :instructor_reserve_request => {'title' => "title", resource_format: 'both', type: "BookReserve", citation: "creator", needed_by: 22.days.from_now, library: "Hesburgh" }} )
      @instructor_reserve = InstructorReserveRequest.new(@controller)
      @instructor_reserve.make_request

      expect(@instructor_reserve.reserve.electronic_reserve).to be_truthy
      expect(@instructor_reserve.reserve.physical_reserve).to be_truthy
    end


    it "resource_format of physical sets physical" do
      @controller.stub(:params).and_return ({ :course_id => @course.id, :instructor_reserve_request => {'title' => "title", resource_format: 'physical', type: "BookReserve", citation: "creator", needed_by: 22.days.from_now, library: "Hesburgh" }} )
      @instructor_reserve = InstructorReserveRequest.new(@controller)
      @instructor_reserve.make_request

      expect(@instructor_reserve.reserve.electronic_reserve).to be_falsey
      expect(@instructor_reserve.reserve.physical_reserve).to be_truthy
    end
  end

end
