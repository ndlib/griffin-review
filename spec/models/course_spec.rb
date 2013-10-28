
require 'spec_helper'

describe Course do

  let(:username) { 'student' }
  let(:semester) { FactoryGirl.create(:semester) }
  let(:course_search) { CourseSearch.new }


  before(:each) do

    VCR.use_cassette "course/crosslist_json" do
      @crosslist_course = CourseSearch.new.get('201310_JE_JH_JJ_JK')
    end

    VCR.use_cassette "course/search_json" do
      @search_json = API::CourseSearchApi.search('accountancy', '201310')
    end

    VCR.use_cassette "course/user_json" do
      @user_json = API::Person.courses('jotousa1', '201310')
    end

  end


  it "has an id " do
    expect(@crosslist_course.id).to eq('201310_JE_JH_JJ_JK')
  end


  it "has supersection ids" do
    @crosslist_course.respond_to?(:unique_supersection_ids).should be_true
    @crosslist_course.unique_supersection_ids.should == ["FA13-ACCT-20100-SSJK"]
  end


  it "has a term_code" do
    @crosslist_course.term.should == '201310'
  end


  it "has a primary_instructor" do
    User.stub(:username).and_return([ double(User, display_name: 'Instructor', new_record?: false) ])

    expect(@crosslist_course.primary_instructor.display_name).to eq("Instructor")
  end


  it "has the section numbers uniq from each section " do
    expect(@crosslist_course.section_numbers).to eq([3, 4, 5, 6])
  end


  it "has the unique crosslist course ids" do
    expect(@crosslist_course.crosslisted_course_ids).to eq(["ACCT 20100", "BAAL 20100", "BAEG 20100", "BASC 20100"])
  end


  describe :enrollment_netids do

    it "lists has an enrollment_netids" do
      @crosslist_course.respond_to?(:enrollment_netids).should be_true
    end


    it "lowercases all enromment_netids" do
      @crosslist_course.sections.first.stub(:enrollment_netids).and_return(['UPPER'])
      expect(@crosslist_course.enrollment_netids.include?('upper')).to be_true
      expect(@crosslist_course.enrollment_netids.include?('UPPER')).to be_false
    end


    it "strips all enromment netids" do
      @crosslist_course.sections.first.stub(:enrollment_netids).and_return([' strip '])
      expect(@crosslist_course.enrollment_netids.include?('strip')).to be_true
      expect(@crosslist_course.enrollment_netids.include?(' strip ')).to be_false
    end


    it "merges all the sections together for the net ids call" do
      total_size = @crosslist_course.sections.collect{ | s | s.enrollment_netids}.flatten.size
      @crosslist_course.enrollment_netids.size.should == total_size
    end


    it "adds in the students who have exceptions " do
      UserCourseException.create_enrollment_exception!(@crosslist_course.id, @crosslist_course.term, 'netid')
      @crosslist_course.enrollment_netids.include?('netid').should be_true
    end

  end


  describe :enrollments do

    it "returns a list of course users" do
      User.stub(:username).and_return([double(User, username: 'jhartzle', display_name: "Jon Hartzler", new_record?: false )])
      expect(@crosslist_course.enrollments.class).to eq(Array)
      expect(@crosslist_course.enrollments.first.class).to eq(CourseUser)
    end

  end



  describe :instructors do

    it "lists all the instructors for a course" do
      @crosslist_course.respond_to?(:instructors).should be_true
    end


    it "merges all the sections together " do
      @crosslist_course.sections.first.stub(:instructor_netids).and_return(["newnetid"])

      User.stub(:username).and_return([double(User, username: 'newnetid', display_name: "Jon Hartzler", new_record?: false )])
      @crosslist_course.instructors[1].username.should == 'newnetid'
    end

    it "lowercases all enromment_netids" do
      @crosslist_course.sections.first.stub(:instructor_netids).and_return(['UPPER'])
      expect(@crosslist_course.instructor_netids.include?('upper')).to be_true
      expect(@crosslist_course.instructor_netids.include?('UPPER')).to be_false
    end


    it "strips all instructor netids" do
      @crosslist_course.sections.first.stub(:instructor_netids).and_return([' strip '])
      expect(@crosslist_course.instructor_netids.include?('strip')).to be_true
      expect(@crosslist_course.instructor_netids.include?(' strip ')).to be_false
    end


    it "removes duplicates" do
      @crosslist_course.sections[0].stub(:instructor_netids).and_return(["wschmuhl"])
      @crosslist_course.sections[1].stub(:instructor_netids).and_return(["wschmuhl"])

      User.stub(:username).and_return([double(User, username: 'newnetid', display_name: "Jon Hartzler", new_record?: false )])
      User.stub(:username).with('wschmuhl').and_return([double(User, username: 'wschmuhl', display_name: "Jon Hartzler", new_record?: false )])

      @crosslist_course.instructors.reject { | i | i.username != "wschmuhl" }.size.should == 1
    end


    it "adds in instructors who have exceptions" do
      User.stub(:username).and_return([double(User, username: 'othernetid', display_name: "Jon Hartzler", new_record?: false )])
      User.stub(:username).with('netid').and_return([double(User, username: 'netid', display_name: "Jon Hartzler", new_record?: false )])

      UserCourseException.create_instructor_exception!(@crosslist_course.id, @crosslist_course.term, 'netid')

      @crosslist_course.instructors.reject { | i | i.username != 'netid'}.size.should == 1
    end

  end


  it "gets the current semester for a course" do
    semester = FactoryGirl.create(:semester, code: "201310")
    @crosslist_course.semester.should == semester
  end


  it "can decide if it has reserves or not"


  describe "reserves" do

    it "returns all the reserves associated with the course reguardless of state" do
      mock_reserve FactoryGirl.create(:request, :new, course_id: @crosslist_course.id), @crosslist_course
      mock_reserve FactoryGirl.create(:request, :inprocess, course_id: @crosslist_course.id), @crosslist_course
      mock_reserve FactoryGirl.create(:request, :available, course_id: @crosslist_course.id), @crosslist_course

      @crosslist_course.reserves.size.should == 3
    end
  end


  describe "published_reserves" do

    it "returns only the published reserves" do
      mock_reserve FactoryGirl.create(:request, :new, course_id: @crosslist_course.id), @crosslist_course
      mock_reserve FactoryGirl.create(:request, :inprocess, course_id: @crosslist_course.id), @crosslist_course
      mock_reserve FactoryGirl.create(:request, :available, course_id: @crosslist_course.id), @crosslist_course

      @crosslist_course.published_reserves.size.should == 1

      @crosslist_course.published_reserves.each do | r |
        r.workflow_state.should == 'available'
      end
    end
  end



end
