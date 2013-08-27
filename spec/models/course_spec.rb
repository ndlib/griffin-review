require 'spec_helper'

describe Course do

  let(:username) { 'student' }
  let(:semester) { FactoryGirl.create(:semester) }
  let(:course_search) { CourseSearch.new }


  before(:each) do
    stub_courses!
    # "current_multisection_crosslisted"
    @course = course_search.get("current_multisection_crosslisted")
  end


  it "has an id " do
    @course.respond_to?(:id).should be_true
    @course.id.should == "current_multisection_crosslisted"
  end


  it "has a title" do
    @course.respond_to?(:title).should be_true
    @course.title.should == "Accountancy I"
  end


  it "has a section_numbers " do
    @course.respond_to?(:section_numbers).should be_true
    @course.section_numbers.should == [10, 11, 12, 13]
  end

  it "has supersection ids" do
    @course.respond_to?(:unique_supersection_ids).should be_true
    @course.unique_supersection_ids.should == ["current_AB_CD","current_EF_GH"]
  end


  it "has a crosslist_id" do
    @course.respond_to?(:crosslist_id).should be_true
    @course.crosslist_id.should == "current_BY_M3_CE_CF"
  end


  it "has a section group id" do
    @course.respond_to?(:section_group_id).should be_true
    @course.section_group_id.should == "current_multisection_crosslisted"
  end


  it "has a term_code" do
    @course.respond_to?(:term).should be_true
    @course.term.should == 'current'
  end


  describe :enrollment_netids do

    it "lists has an enrollment_netids" do
      @course.respond_to?(:enrollment_netids).should be_true
    end


    it "merges all the sections together for the net ids call" do
      total_size = @course.sections.collect{ | s | s['enrollments']}.flatten.size
      @course.enrollment_netids.size.should == total_size
    end


    it "adds in the students who have exceptions " do
      @course.add_enrollment_exception!('netid')
      @course.enrollment_netids.include?('netid').should be_true
    end

  end


  describe :enrollments do

    it "returns a list of course users" do
      User.stub(:username).and_return([double(User, username: 'jhartzle', display_name: "Jon Hartzler", new_record?: false )])
      expect(@course.enrollments.class).to eq(Array)
      expect(@course.enrollments.first.class).to eq(CourseUser)
    end

  end



  describe :instructors do

    it "lists all the instructors for a course" do
      @course.respond_to?(:instructors).should be_true
    end


    it "merges all the sections together " do
      @course.attributes['sections'][1]['instructors'] << {
          "id"=>"newnetid",
            "identifier_contexts"=>{"ldap"=>"uid", "staff_directory"=>"email"},
            "identifier"=>"by_netid",
            "netid"=>"newnetid",
            "first_name"=>"New",
            "last_name"=>"Guy",
            "full_name"=>"New Guy",
            "ndguid"=>"otherguid",
            "position_title"=>"Associate Professional Specialist",
            "campus_department"=>"Accountancy",
            "primary_affiliation"=>"Staff"
      }

      User.stub(:username).and_return([double(User, username: 'newnetid', display_name: "Jon Hartzler", new_record?: false )])

      @course.instructors[1].username.should == 'newnetid'
    end


    it "removes duplicates" do
      @course.attributes['sections'][0]['instructors'][0]['netid'].should == "wschmuhl"
      @course.attributes['sections'][1]['instructors'][0]['netid'].should == "wschmuhl"

      User.stub(:username).and_return([double(User, username: 'newnetid', display_name: "Jon Hartzler", new_record?: false )])
      User.stub(:username).with('wschmuhl').and_return([double(User, username: 'wschmuhl', display_name: "Jon Hartzler", new_record?: false )])

      @course.instructors.reject { | i | i.username != "wschmuhl" }.size.should == 1
    end


    it "adds in instructors who have exceptions" do
      User.stub(:username).and_return([double(User, username: 'othernetid', display_name: "Jon Hartzler", new_record?: false )])
      User.stub(:username).with('netid').and_return([double(User, username: 'netid', display_name: "Jon Hartzler", new_record?: false )])

      @course.add_instructor_exception!('netid')
      @course.instructors.reject { | i | i.username != 'netid'}.size.should == 1
    end

  end


  it "gets the current semester for a course" do
    semester

    @course.respond_to?(:semester).should be_true
    @course.semester.should == semester
  end


  it "can decide if it has reserves or not"


  describe "reserves" do

    it "returns all the reserves associated with the course reguardless of state" do
      mock_reserve FactoryGirl.create(:request, :new, course_id: @course.id), @course
      mock_reserve FactoryGirl.create(:request, :inprocess, course_id: @course.id), @course
      mock_reserve FactoryGirl.create(:request, :available, course_id: @course.id), @course

      @course.reserves.size.should == 3
    end
  end


  describe "published_reserves" do

    it "returns only the published reserves" do
      mock_reserve FactoryGirl.create(:request, :new, course_id: @course.id), @course
      mock_reserve FactoryGirl.create(:request, :inprocess, course_id: @course.id), @course
      mock_reserve FactoryGirl.create(:request, :available, course_id: @course.id), @course

      @course.published_reserves.size.should == 1

      @course.published_reserves.each do | r |
        r.workflow_state.should == 'available'
      end
    end
  end



end
