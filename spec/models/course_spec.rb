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
    @course.title.should == "current_CSC_33963"
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


  it "has a supersection_id" do
    @course.respond_to?(:supersection_id).should be_true
  end


  describe "supersectiosn" do

    before(:each) do
      @supersection_course = course_api.get("current_29781", 'supersections')
      @course.join_to_supersection(@supersection_course)
    end

    describe "has_supersection?" do
      it "returns true if the class has a super section" do
        @supersection_course.has_supersection?.should be_true
      end

      it "returns false if the class does not have a supersection" do
        @course.has_supersection?.should be_false
      end
    end

    it "allows you to join courses that are supersections to this course" do
      @course.supersections.collect{|c| c.id}.should == [@course, @supersection_course].collect{|c| c.id}
    end


    it "returns all the supersections sections " do
      @course.supersection_section_ids.should == [@course.section, @supersection_course.section]
    end


    it "returns all the supersections course ids" do
      @course.supersection_course_ids.should == [@course.id, @supersection_course.id]
    end


    it "returns all the section ids for the super sections" do
      @course.supersection_section_ids.should == [@course.section, @supersection_course.section]
    end


    it "displays the super sections with a comma" do
      @course.display_supersection_section_ids.should == "#{@course.section}, #{@supersection_course.section}"
    end


    it "ignores duplicate courses that are joined " do
      @course.join_to_supersection(@supersection_course)
      @course.supersections.size.should == 2
    end
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
    before(:each) do
      @crosslisting_course = course_api.get("current_crosslisting", 'crosslisting')
    end

    it "has cross listings" do
      @crosslisting_course.cross_listings.size.should == 1
    end

    it "has the correct title" do
      lists = @crosslisting_course.cross_listings
      lists.first.title.should == "current_BAUG_20001"
    end

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
