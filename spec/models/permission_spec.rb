require 'spec_helper'

describe Permission do
  let(:student_user) { mock(User, :username => 'student') }
  let(:instructor_user) { mock(User, :username => 'instructor') }
  let(:inst_stu_user)  { mock(User, :username => 'inst_stu') }

  let(:semester) { FactoryGirl.create(:semester)}
  let(:semester_code) { semester.code }

  before(:each) do
    stub_courses!
  end

  describe :current_user_instructs_course? do

    it "returns true if the current user is an instructor for the course" do
      perm = Permission.new(instructor_user)

      reserves = UserCourseListing.new(instructor_user, semester_code)
      course = reserves.instructed_courses.first

      perm.current_user_instructs_course?(course).should be_true
    end


    it "returns false if the current user does not instruct the course" do
      perm = Permission.new(student_user)

      inst_reserves = UserCourseListing.new(instructor_user, semester_code)
      course = inst_reserves.instructed_courses.first

      perm.current_user_instructs_course?(course).should be_false
    end
  end


  describe :current_user_enrolled_in_course? do

    it "returns true if the current user is enrolled in the course" do
      perm = Permission.new(student_user)

      reserves = UserCourseListing.new(student_user, semester_code)
      course = reserves.enrolled_courses.first

      perm.current_user_enrolled_in_course?(course).should be_true
    end


    it "returns false if the the user is not enrolled in the course" do
      perm = Permission.new(student_user)

      other_reserves = UserCourseListing.new(inst_stu_user, semester_code)
      course = other_reserves.enrolled_courses.first

      perm.current_user_enrolled_in_course?(course).should be_false
    end
  end

end
