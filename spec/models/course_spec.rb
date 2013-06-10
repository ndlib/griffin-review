require 'spec_helper'

describe Course do

  let(:username) { 'student' }
  let(:semester) { FactoryGirl.create(:semester) }
  let(:course_api) { CourseApi.new }


  before(:each) do
    stub_courses!
    # "current_multisection_crosslisted"
    @course = course_api.get("current_multisection_crosslisted")
  end


  it "has an id / crn " do
    @course.respond_to?(:id).should be_true
    @course.id.should == "current_multisection_crosslisted"
  end

  it "has a reserve_id" do
    @course.respond_to?(:reserve_id).should be_true
  end


  it "has a reserve_id that is the combo of the section_group_id and crosslist_id" do
    @course.reserve_id.should == "#{@course.crosslist_id}-#{@course.section_group_id}"
  end


  it "has a title" do
    @course.respond_to?(:title).should be_true
    @course.title.should == "Accountancy I"
  end


  it "has an instructor_name" do
    @course.respond_to?(:instructor_name).should be_true
    @course.instructor_name.should == "William Schmuhl"
  end


  it "has a section_numbers " do
    @course.respond_to?(:section_numbers).should be_true
    @course.section_numbers.should == [10, 11, 12, 13]
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


  describe :enrollments do

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

      @course.instructors[1]['netid'].should == 'newnetid'
    end


    it "removes duplicates" do
      @course.attributes['sections'][0]['instructors'][0]['netid'].should == "wschmuhl"
      @course.attributes['sections'][1]['instructors'][0]['netid'].should == "wschmuhl"

      @course.instructors.reject { | i | i['netid'] != "wschmuhl" }.size.should == 1
    end


    it "adds in instructors who have exceptions" do
      @course.add_instructor_exception!('netid')
      @course.instructors.reject { | i | i['netid'] != 'netid'}.size.should == 1
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
      mock_reserve FactoryGirl.create(:request, :new, course_id: @course.reserve_id), @course
      mock_reserve FactoryGirl.create(:request, :inprocess, course_id: @course.reserve_id), @course
      mock_reserve FactoryGirl.create(:request, :available, course_id: @course.reserve_id), @course

      @course.reserves.size.should == 3
    end
  end


  describe "published_reserves" do

    it "returns only the published reserves" do
      mock_reserve FactoryGirl.create(:request, :new, course_id: @course.reserve_id), @course
      mock_reserve FactoryGirl.create(:request, :inprocess, course_id: @course.reserve_id), @course
      mock_reserve FactoryGirl.create(:request, :available, course_id: @course.reserve_id), @course

      @course.published_reserves.size.should == 1

      @course.published_reserves.each do | r |
        r.workflow_state.should == 'available'
      end
    end
  end


  describe :get_term_from_course do

    it "returns the term from the code" do
      Course.get_semester_from("term_adsf_asdfasd_adsfasd_adsfasd_234234").should == 'term'
    end

  end

end
