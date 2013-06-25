require 'spec_helper'

describe UserCourseListing do

  let(:student_user) { mock(User, :username => 'student') }
  let(:instructor_user) { mock(User, :username => 'instructor') }
  let(:inst_stu_user)  { mock(User, :username => 'inst_stu') }

  let(:semester) { FactoryGirl.create(:semester)}
  let(:previous_semester) { FactoryGirl.create(:previous_semester)}

  before(:each) do
    semester
    stub_courses!
  end


  describe :instructed_courses do
    it "returns a list of both the current upcoming instructed courses" do
      FactoryGirl.create(:next_semester)

      reserves = UserCourseListing.new(instructor_user)
      reserves.instructed_courses.size.should == 2
    end
  end


  describe :current_instructed_courses do
    it "returns all the instructed courses" do
      reserves = UserCourseListing.new(instructor_user)
      reserves.current_instructed_courses.size.should == 1
      reserves.current_instructed_courses.first.id.should == "current_21258_20334_20452_20237"
    end
  end


  describe :upcoming_instructed_courses do
    it "returns all the instructed courses for the next semester" do
      FactoryGirl.create(:next_semester)

      reserves = UserCourseListing.new(instructor_user)
      reserves.upcoming_instructed_courses.size.should == 1
      reserves.upcoming_instructed_courses.first.id.should == "next_25823"
    end


    it "returns an empty array if there is no next semester" do
      reserves = UserCourseListing.new(instructor_user)
      reserves.upcoming_instructed_courses.should == []
    end

  end



  describe :enrolled_courses do

    it "returns a list of courses that have reserves for the current user" do
      reserves = UserCourseListing.new(student_user)

      course = CourseSearch.new.enrolled_courses(student_user.username, reserves.current_semester.code).first
      mock_reserve FactoryGirl.create(:request, :available, course_id: course.reserve_id), course

      reserves.enrolled_courses.size.should == 1
    end


    it "return [] if the student has no reserves in the specified semester" do
      reserves = UserCourseListing.new(student_user)
      reserves.enrolled_courses.should == []
    end


    it "only returns courses with reserves" do
      reserves = UserCourseListing.new(student_user)
      courses  = CourseSearch.new.enrolled_courses(student_user.username, reserves.current_semester.code)

      mock_reserve FactoryGirl.create(:request, :available, course_id: courses.first.reserve_id), courses.first

      reserves.enrolled_courses.size.should_not == courses.size
    end

  end



  describe :all_semsters do

    it "orders them cronologically" do
      reserves = UserCourseListing.new(instructor_user)
      ps = previous_semester
      cs = semester

      reserves.all_semesters.first.id.should == cs.id
      reserves.all_semesters.last.id.should == ps.id
    end
  end


  describe :current_semester do

    it "selects the current semester" do
      reserves = UserCourseListing.new(instructor_user)
      ps = previous_semester
      cs = semester

      reserves.current_semester.id.should == cs.id
    end
  end


  describe :next_semester do

    it "gets the next semester after the current semester" do
      next_semester = FactoryGirl.create(:next_semester)

      reserves = UserCourseListing.new(instructor_user)
      reserves.next_semester.should == next_semester
    end
  end
end
