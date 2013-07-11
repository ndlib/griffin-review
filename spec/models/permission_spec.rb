require 'spec_helper'

describe Permission do
  let(:student_user) { mock(User, :username => 'student', :admin? => false) }
  let(:instructor_user) { mock(User, :username => 'instructor', :admin? => false) }
  let(:inst_stu_user)  { mock(User, :username => 'inst_stu', :admin? => false) }
  let(:admin_user) { mock(User, username: 'admin', admin?: true) }
  let(:controller) { mock(ApplicationController, :session => {} )}
  let(:course) { mock(Course) }


  describe :current_user_instructs_course? do

    it "returns true if the current user is an instructor for the course" do
      UserRoleInCoursePolicy.any_instance.stub(:user_instructs_course?).and_return(true)
      Permission.new(instructor_user, controller).current_user_instructs_course?(course).should be_true
    end


    it "returns false if the current user does not instruct the course" do
      UserRoleInCoursePolicy.any_instance.stub(:user_instructs_course?).and_return(false)
      Permission.new(student_user, controller).current_user_instructs_course?(course).should be_false
    end
  end


  describe :current_user_enrolled_in_course? do

    it "returns true if the current user is enrolled in the course" do
      UserRoleInCoursePolicy.any_instance.stub(:user_enrolled_in_course?).and_return(true)
      Permission.any_instance.stub(:course_in_current_semester?).and_return(true)

      Permission.new(student_user, controller).current_user_enrolled_in_course?(course).should be_true
    end


    it "returns false if the the user is not enrolled in the course" do
      UserRoleInCoursePolicy.any_instance.stub(:user_enrolled_in_course?).and_return(false)
      Permission.any_instance.stub(:course_in_current_semester?).and_return(true)

      Permission.new(student_user, controller).current_user_enrolled_in_course?(course).should be_false
    end


    it "returns false if the course is not in the current semester" do
      UserRoleInCoursePolicy.any_instance.stub(:user_enrolled_in_course?).and_return(true)
      Permission.any_instance.stub(:course_in_current_semester?).and_return(false)

      Permission.new(student_user, controller).current_user_enrolled_in_course?(course).should be_false
    end
  end


  describe :current_user_is_admin? do

    it "returns true if the user is marked as an admin"   do
      Permission.new(admin_user, controller).current_user_is_administrator?.should be_true
    end


    it "returns false if the is no an admin" do
      Permission.new(student_user, controller).current_user_is_administrator?.should be_false
    end
  end


  describe :current_user_is_admin_in_masquerade? do

    it "returns true if the masqing users is an admin " do
      Masquerade.any_instance.stub(:masquerading?).and_return(true)
      Masquerade.any_instance.stub(:original_user).and_return(admin_user)

      Permission.new(student_user, controller).current_user_is_admin_in_masquerade?.should be_true
    end

    it "returns false if the masqing users is not an admin" do
      Masquerade.any_instance.stub(:masquerading?).and_return(true)
      Masquerade.any_instance.stub(:original_user).and_return(instructor_user)

      Permission.new(student_user, controller).current_user_is_admin_in_masquerade?.should be_false
    end

  end

end
