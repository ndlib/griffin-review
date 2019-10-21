require 'spec_helper'


describe UserRoleInCoursePolicy do

  describe "#user_enrolled_in_course?" do
    it "returns trud if the user is enrolled in the course" do
      course = double(Course, :enrollment_netids => ['netid'])
      user = double(User, :username => 'netid' )

      UserRoleInCoursePolicy.new(course, user).user_enrolled_in_course?.should be_truthy
    end

    it "returns false if the user is not enrolled in the course" do
      course = double(Course, :id => 4, :enrollment_netids => ['other_netid'])
      user = double(User, :username => 'netid' )

      UserRoleInCoursePolicy.new(course, user).user_enrolled_in_course?.should be_falsey
    end


    it "returns false if the user instucts the course" do
      course = double(Course, :id => 4, :instructor_netids => ['netid'], :enrollment_netids => ['student'])
      user = double(User, :username => 'netid' )

      UserRoleInCoursePolicy.new(course, user).user_enrolled_in_course?.should be_falsey
    end

    it "returns true if the course is the test course" do
      course = double(Course, :id => '12345678_54321_LR', :enrollment_netids => [])
      user = double(User, :username => 'netid' )
    end
  end


  describe "#user_instructs_course?" do
    it "returns true if the user instructs the course" do
      course = double(Course, :instructor_netids => ['netid'])
      user = double(User, :username => 'netid' )

      UserRoleInCoursePolicy.new(course, user).user_instructs_course?.should be_truthy
    end


    it "returns false if the user instrcuts the course" do
      course = double(Course, :instructor_netids => ['other_netid'])
      user = double(User, :username => 'netid' )

      UserRoleInCoursePolicy.new(course, user).user_instructs_course?.should be_falsey
    end


    it "returns false if the user is enrolled in the course" do
      course = double(Course, :enrollment_netids => ['netid'], :instructor_netids => ['teachy'])
      user = double(User, :username => 'netid' )

      UserRoleInCoursePolicy.new(course, user).user_instructs_course?.should be_falsey
    end
  end

end
