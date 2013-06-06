require 'spec_helper'

describe Item do

  let(:semester) { FactoryGirl.create(:semester) }
  let(:previous_semester) { FactoryGirl.create(:previous_semester) }

  describe "validations" do

    it "requires the netid" do
      UserCourseException.new.should have(1).error_on(:netid)
    end


    it "requires role" do
      UserCourseException.new.should have(2).error_on(:role)
    end


    it "requires a semester_code" do
      UserCourseException.new.should have(1).error_on(:semester_code)
    end


    it "requires the role is either a student or instructor " do
      [
        'adfasf',
        '32423423',
        234234234,
        Object.new
      ].each do | r |
        UserCourseException.new(role: r).should have(1).error_on(:netid)
      end
    end

  end

  describe :user_course_exceptions do

    it "returns all the exceptions for the netid " do
      UserCourseException.create_student_exception!("course_id", semester.id , "netid")
      UserCourseException.create_instructor_exception!("course_id", semester.id, "netid")
      UserCourseException.create_instructor_exception!("course_id", semester.id, "other_netid")

      UserCourseException.user_course_exceptions('netid', semester.id).size.should == 2
    end


    it "returns all the exceptions for the semester" do
      UserCourseException.create_student_exception!("course_id", semester.id , "netid")
      UserCourseException.create_instructor_exception!("course_id", semester.id, "netid")
      UserCourseException.create_instructor_exception!("course_id", previous_semester.id, "netid")

      UserCourseException.user_course_exceptions('netid', semester.id).size.should == 2
    end

  end


  describe :create_student_exception! do

    it "saves with valid params" do
      lambda {
        UserCourseException.create_student_exception!("course_id", semester.id , "netid")
      }.should_not raise_error
    end
  end


  describe :create_instructor_exception! do
    it "saves with valid params" do
      lambda {
        UserCourseException.create_instructor_exception!("course_id", semester.id, "netid")
      }.should_not raise_error
    end

  end
end
