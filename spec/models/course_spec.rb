require 'spec_helper'

describe Course do

  let(:username) { 'student' }
  let(:semester_code) { FactoryGirl.create(:semester).code }
  let(:course_api) { CourseApi.new }


  before(:each) do
    stub_courses!
    @course = course_api.get("current_22557", username)
  end


  it "has a title" do
    @course.respond_to?(:title).should be_true
    @course.title.should == "201220_CSC_33963"
  end


  it "has an instructor_name" do
    @course.respond_to?(:instructor_name).should be_true
    @course.instructor_name.should == 'William Purcell'
  end


  it "has an id / crn " do
    @course.respond_to?(:id).should be_true
    @course.id.should == "current_22557"
  end


  it "has a section " do
    @course.respond_to?(:section).should be_true
    @course.section.should == "01"
  end


  it "can decide if it has reserves or not"


  describe "reserves" do

    it "returns all the reserves associated with the course" do
      @course.reserves.size.should == 12
    end
  end


  describe "published_reserves" do

    it "returns only the published reserves" do
      @course.published_reserves.size.should == 6

      @course.published_reserves.each do | r |
        r.status.should == 'complete'
      end
    end
  end


  describe :cross_listings do

    it "has cross listings"

    it "allows you to add a cross listing"

    it "allows you to remove a added cross listing"

    it "replaces an added cross listing with one from banner if one now exists"

  end


  describe :new_reserve do

    it "makes a new reserve object" do
      @course.new_reserve.should_not be_nil
    end

    it "associates the course with the reserve object" do
      @course.new_reserve.course.should == @course
    end
  end


end
