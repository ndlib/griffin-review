require 'spec_helper'

describe UserCourseException do

  let(:semester) { FactoryGirl.create(:semester) }
  let(:previous_semester) { FactoryGirl.create(:previous_semester) }

  describe "validations" do

    it "requires the netid" do
      UserCourseException.new.should have(1).error_on(:netid)
    end


    it "requires role" do
      UserCourseException.new.should have(2).error_on(:role)
    end


    it "requires a term" do
      UserCourseException.new.should have(1).error_on(:term)
    end

    it "requires a course_id" do
      UserCourseException.new.should have(1).error_on(:course_id)
    end


    it "requires the role is either a enrollment or instructor " do
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

  describe :user_exceptions do

    it "returns all the exceptions for the netid " do
      UserCourseException.create_enrollment_exception!("course_id", semester.id , "netid")
      UserCourseException.create_instructor_exception!("course_id", semester.id, "netid")
      UserCourseException.create_instructor_exception!("course_id", semester.id, "other_netid")

      UserCourseException.user_exceptions('netid', semester.id).size.should == 2
    end


    it "returns all the exceptions for the semester" do
      UserCourseException.create_enrollment_exception!("course_id", semester.id , "netid")
      UserCourseException.create_instructor_exception!("course_id", semester.id, "netid")
      UserCourseException.create_instructor_exception!("course_id", previous_semester.id, "netid")

      UserCourseException.user_exceptions('netid', semester.id).size.should == 2
    end

  end


  describe :user_course_exception do

    it "returns the exception for the user semester and course" do
      test_exception = UserCourseException.create_enrollment_exception!("course_id", semester.id , "netid")
      UserCourseException.create_enrollment_exception!("other_course_id", semester.id , "netid")
      UserCourseException.create_enrollment_exception!("course_id", previous_semester.id , "netid")
      UserCourseException.create_enrollment_exception!("course_id", semester.id , "other_netid")

      expect(UserCourseException.user_course_exception('course_id', 'netid', semester.id).id).to eq(test_exception.id)
    end
  end


  describe :create_enrollment_exception! do

    it "saves with valid params" do
      lambda {
        UserCourseException.create_enrollment_exception!("course_id", semester.id , "netid")
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
