require 'spec_helper'

describe Course do

  let(:username) { 'student' }
  let(:semester_code) { FactoryGirl.create(:semester).code }
  let(:course_api) { CourseApi.new }


  before(:each) do
    stub_courses!
    @course = course_api.get(username, "current_normalclass_100")
  end


  it "has an id / crn " do
    @course.respond_to?(:id).should be_true
    @course.id.should == "current_normalclass_100"
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
    @course.instructor_name.should == 'fagostin'
  end


  it "has a section_number " do
    @course.respond_to?(:section_number).should be_true
    @course.section_number.should == 2
  end


  it "has a section" do
    @course.respond_to?(:section).should be_true
  end


  it "has a crosslist_id" do
    @course.respond_to?(:crosslist_id).should be_true
    @course.crosslist_id.should == "current_BP"
  end


  it "has a section group id" do
    @course.respond_to?(:section_group_id).should be_true
    @course.section_group_id.should == "current_11389"
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


end
