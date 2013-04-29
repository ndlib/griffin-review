require 'spec_helper'

describe Course do

  before(:each) do
    @course = Course.new('title' => 'Course 1', :instructor => 'Instructor', :cross_listings => [ 'cross listing'], :current_user => 'User')
  end


  it "has a title" do
    @course.title.should == 'Course 1'
  end


  it "has an instructor" do
    @course.instructor.should == 'Instructor'
  end


  it "has the current user" do
    @course.current_user.should == 'User'
  end


  describe :cross_listings do

    it "has cross listings" do
      @course.cross_listings.should == [ 'cross listing' ]
    end

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


  describe :new_request_reserve do

    it "returns a request object" do
      @course.new_request_reserve.class.should == RequestReserve
    end


    it "adds the request to the course" do
      @course.new_reserve.course.should == @course
    end


    it "allows you to add attributes in" do
       @course.new_request_reserve(title: "THE TITLE").title.should == "THE TITLE"
    end
  end


  describe :get_reserve do

    it "returns a GetReserve obj" do
      @course.get_reserve(1).class.should == GetReserve
    end
  end

  it "can decide if it has reserves or not"
end
