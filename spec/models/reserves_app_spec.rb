require 'spec_helper'

describe ReservesApp do

  let(:reserves) { ReservesApp.new("current_user", semester.id)}
  let(:semester) { FactoryGirl.create(:semester)}

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

    it "returns results only for the current semester" do
      reserves.courses_without_reserves.size.should == 2
    end


    it "returns results for the previous_semester" do
      ps = FactoryGirl.create(:previous_semester)

      reserves = ReservesApp.new("current_user", ps.id)
      reserves.courses_without_reserves.size.should == 1
    end

  end


  describe :courses_without_reserves do

    it "returns a list of courses that have do not have reserves for the current user" do
      reserves.courses_without_reserves.size.should == 2
    end

    it "return [] if the student has no classes with out reserves in the specified semester"

    it "only returns courses without reserves"


    it "returns results only for the current semester" do
      reserves.courses_without_reserves.size.should == 2
    end

    it "returns results for the previous_semester" do
      ps = FactoryGirl.create(:previous_semester)

      reserves = ReservesApp.new("current_user", ps.id)
      reserves.courses_without_reserves.size.should == 1
    end

  end


  describe :all_semsters do

    it "orders them cronologically" do
      ps = FactoryGirl.create(:previous_semester)
      cs = FactoryGirl.create(:semester)

      reserves.all_semesters.first.should == cs
      reserves.all_semesters.last.should == ps
    end

  end


  describe :semester do

    it "selects the current semester if no semester is passed in" do
      ps = FactoryGirl.create(:previous_semester)
      cs = FactoryGirl.create(:semester)

      reserve = ReservesApp.new("current_user")
      reserve.semester.should == cs
    end


    it "finds the semester by id that was passed into the constructor" do
      ps = FactoryGirl.create(:previous_semester)
      cs = FactoryGirl.create(:semester)

      reserve = ReservesApp.new("current_user", ps.id)
      reserve.semester.should == ps
    end
  end


  describe :copy_course_listings do

    it "returns a copy course listing" do
      reserves.copy_course_listing(1, 2).class.should == CopyReserves
    end

  end

end
