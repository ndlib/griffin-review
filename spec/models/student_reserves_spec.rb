require 'spec_helper'

describe StudentReserves do

  let(:student_reserves) { StudentReserves.new("current_user", "semester")}

  describe :course do

    it "returns a course the student belongs to" do
      student_reserves.course("1").title.should == "Course 1"
      student_reserves.course("1").instructor.should == "Instructor"
    end

    it "returns nil if the student is not a part of the class"

    it "returns nil if the course is not in the current semester passed into student reserves"
  end


  describe :courses_with_reserves do

    it "returns a list of courses that have reserves for the current user" do
      student_reserves.courses_with_reserves.size.should == 2
    end

    it "return [] if the student has no reserves in the specified semester"

    it "only returns courses with reserves"

  end


  describe :courses_without_reserves do

    it "returns a list of courses that have do not have reserves for the current user" do
      student_reserves.courses_without_reserves.size.should == 2
    end

    it "return [] if the student has no classes with out reserves in the specified semester"

    it "only returns courses without reserves"

  end

end
