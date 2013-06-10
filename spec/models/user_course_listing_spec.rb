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

  describe :course do

    it "returns a course the student belongs to" do
      Course.any_instance.stub(:enrollment_netids).and_return([student_user.username])
      reserves = UserCourseListing.new(student_user, semester.code)

      reserves.course("current_multisection_crosslisted").title.should == "Accountancy I"
      reserves.course("current_multisection_crosslisted").instructor_name.should == "William Schmuhl"
    end


    it "returns nil if the user is not a part of the class" do
      Course.any_instance.stub(:enrollment_netids).and_return(['othernetid', 'somenetid'])
      reserves = UserCourseListing.new(student_user, semester.code)

      reserves.course("current_multisection_crosslisted").should be_nil
    end


    it "returns the course even if the course is not in the current semester passed" do
      Course.any_instance.stub(:enrollment_netids).and_return([student_user.username])

      reserves = UserCourseListing.new(student_user, semester.code)
      reserves.course("previous_multisection").should_not be_nil

      prev_reserves = UserCourseListing.new(student_user, previous_semester.code)
      prev_reserves.course("previous_multisection").should_not be_nil
    end

  end


  describe :instructed_courses_with_reserves do

    it "returns a list of courses that have reserves for the current user" do
      reserves = UserCourseListing.new(instructor_user, semester.code)

      course = reserves.instructed_courses.first
      mock_reserve FactoryGirl.create(:request, :new, course_id: course.reserve_id), course

      reserves.instructed_courses_with_reserves.size.should == 1
    end

    it "returns a list of instructed couses for the semester setup in reserves"
  end


  describe :instructed_courses do

    it "returns all the instructed courses" do
      reserves = UserCourseListing.new(instructor_user, semester.code)
      reserves.instructed_courses.size.should == 1
    end

  end


  describe :courses_with_reserves do

    it "returns a list of courses that have reserves for the current user" do
      reserves = UserCourseListing.new(student_user, semester.code)

      course = reserves.enrolled_courses.first
      mock_reserve FactoryGirl.create(:request, :available, course_id: course.reserve_id), course

      reserves.courses_with_reserves.size.should == 1
    end

    it "return [] if the student has no reserves in the specified semester"

    it "only returns courses with reserves"

    it "returns results only for the current semester not a passed in semester" do
      reserves = UserCourseListing.new(student_user, semester.code)
      prev_reserves = UserCourseListing.new(student_user, previous_semester.code)

      prev_reserves.courses_with_reserves.collect{ |c| c.id}.should == reserves.courses_with_reserves.collect{ |c| c.id}
    end

  end


  describe :enrolled_courses do

    it "returns all the courses the current user is enrolled in" do
      reserves = UserCourseListing.new(student_user, semester.code)
      reserves.enrolled_courses.size.should == 11
    end


    it "returns results only for the current semester not a passed in semester" do
      reserves = UserCourseListing.new(student_user, semester.code)
      prev_reserves = UserCourseListing.new(student_user, previous_semester.code)

      prev_reserves.enrolled_courses.collect{ |c| c.id}.should == reserves.enrolled_courses.collect{ |c| c.id}
    end
  end



  describe :all_semsters do

    it "orders them cronologically" do
      reserves = UserCourseListing.new(instructor_user, semester.code)
      ps = previous_semester
      cs = semester

      reserves.all_semesters.first.id.should == cs.id
      reserves.all_semesters.last.id.should == ps.id
    end
  end


  describe :semester do

    it "selects the current semester if no semester is passed in" do
      reserves = UserCourseListing.new(instructor_user, semester.code)
      ps = previous_semester
      cs = semester

      reserve = UserCourseListing.new("current_user")
      reserve.semester.id.should == cs.id
    end


    it "finds the semester by id that was passed into the constructor" do
      reserves = UserCourseListing.new(instructor_user, semester.code)
      ps = previous_semester
      cs = semester

      reserve = UserCourseListing.new("current_user", ps.code)
      reserve.semester.id.should == ps.id
    end
  end



    describe "course exceptions" do

    it "merges student exceptions into the student couse list" do
      UserCourseException.create_enrollment_exception!('18879', semester.code, 'student')

      courses = course_api.enrolled_courses('student', 'current')
      test_result_has_course_ids(courses, ['current_normalclass_100', 'current_supersection_100', 'current_HIST_32350'])
    end


    it "mergers instructor exceptions into the instructor course list" do
      UserCourseException.create_instructor_exception!('18879', semester.code, 'instructor')

      courses = course_api.instructed_courses('instructor', 'current')
      test_result_has_course_ids(courses, ['current_ACCT_20200', 'current_HIST_32350' ])
    end


    it "creates a course object for the passed in course" do
      UserCourseException.create_instructor_exception!('18879', semester.code, 'instructor')

      courses = course_api.instructed_courses('instructor', 'current')

      courses.last.class.should == Course
    end
  end
end
