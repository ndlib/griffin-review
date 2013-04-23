require 'spec_helper'

describe ReservesApp do

  let(:reserves) { ReservesApp.new("current_user", "semester")}


  describe :course do

    it "returns a course the student belongs to" do
      reserves.course("1").title.should == "Course 1"
      reserves.course("1").instructor.should == "Instructor"
    end

    it "returns nil if the student is not a part of the class"

    it "returns nil if the course is not in the current semester passed into student reserves"
  end


  describe :courses_with_reserves do

    it "returns a list of courses that have reserves for the current user" do
      reserves.courses_with_reserves.size.should == 2
    end

    it "return [] if the student has no reserves in the specified semester"

    it "only returns courses with reserves"

  end


  describe :courses_without_reserves do

    it "returns a list of courses that have do not have reserves for the current user" do
      reserves.courses_without_reserves.size.should == 2
    end

    it "return [] if the student has no classes with out reserves in the specified semester"

    it "only returns courses without reserves"

  end


  describe :all_semsters do

    it "orders them cronologically" do
      ps = FactoryGirl.create(:previous_semester)
      cs = FactoryGirl.create(:semester)

      reserves.all_semesters.first.should == cs
      reserves.all_semesters.last.should == ps
    end

  end


  describe :current_semester do


  end


  describe :copy_course_listings do

    it "returns a copy course listing" do
      reserves.copy_course_listing(1, 2).class.should == CopyCourseListings
    end

  end



end
