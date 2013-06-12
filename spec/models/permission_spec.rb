require 'spec_helper'

describe Permission do
  let(:student_user) { mock(User, :username => 'student') }
  let(:instructor_user) { mock(User, :username => 'instructor') }
  let(:inst_stu_user)  { mock(User, :username => 'inst_stu') }
  let(:course) { mock(Course) }


  describe :current_user_instructs_course? do

    it "returns true if the current user is an instructor for the course" do
      UserRoleInCoursePolicy.any_instance.stub(:user_instructs_course?).and_return(true)
      Permission.new(instructor_user).current_user_instructs_course?(course).should be_true
    end


    it "returns false if the current user does not instruct the course" do
      UserRoleInCoursePolicy.any_instance.stub(:user_instructs_course?).and_return(false)
      Permission.new(student_user).current_user_instructs_course?(course).should be_false
    end
  end


  describe :current_user_enrolled_in_course? do

    it "returns true if the current user is enrolled in the course" do
      UserRoleInCoursePolicy.any_instance.stub(:user_enrolled_in_course?).and_return(true)
      Permission.new(student_user).current_user_enrolled_in_course?(course).should be_true
    end


    it "returns false if the the user is not enrolled in the course" do
      UserRoleInCoursePolicy.any_instance.stub(:user_enrolled_in_course?).and_return(false)
      Permission.new(student_user).current_user_enrolled_in_course?(course).should be_false
    end
  end

end
