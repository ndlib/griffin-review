require 'spec_helper'

describe CourseApi do

  let(:course_api) { CourseApi.new }
  let(:semester) { FactoryGirl.create(:semester)}

  before(:each) do
    stub_courses!
  end


  describe "api_access" do
    it "only calls the api once for enrolled and instucted courses per netid and semster"
  end


  describe "#enrolled_courses" do

    it "returns the students enrolled courses for the current semseter" do
      courses = course_api.enrolled_courses('student', 'current')
      display_course_ids(courses)
      test_result_has_course_ids(courses, ['current_normalclass_100', 'current_supersection_100'])
    end

    it "returns the students enrolled courses for the previous semseter" do
      courses = course_api.enrolled_courses('student', 'previous')
      test_result_has_course_ids(courses, ["previous_ACCT_20200", "previous_AFST_20476", "previous_BAET_20300"])
    end

    it "returns the inst_stu's enrolled courses for the current semester" do
      courses = course_api.enrolled_courses('inst_stu', 'current')
      test_result_has_course_ids(courses, ["current_ACMS_98698"])
    end

    it "returns the inst_stu's enrolled courses for the previous semester" do
      courses = course_api.enrolled_courses('inst_stu', 'previous')
      test_result_has_course_ids(courses, ["previous_ACMS_60882", "previous_ACMS_60890", "previous_ACMS_70870"])
    end

    it "returns the instructors enrolled courses for the current semester" do
      course_api.enrolled_courses('instructor', 'current').size.should == 0
    end

    it "returns the instructors enrolled courses for the previous semester" do
      course_api.enrolled_courses('instructor', 'previous').size.should == 0
    end
  end


  describe "#instructed_courses" do

    it "returns the students instructed courses for the current semseter" do
      course_api.instructed_courses('student', 'current').size.should == 0
    end


    it "returns the students instructed courses for the previous semseter" do
      course_api.instructed_courses('student', 'previous').size.should == 0
    end


    it "returns the inst_stu's instructed courses for the current semester" do
      courses = course_api.instructed_courses('inst_stu', 'current')
      test_result_has_course_ids(courses, ["current_ACMS_10145"])
    end


    it "returns the inst_stu's instructed courses for the previous semester" do
      courses = course_api.instructed_courses('inst_stu', 'previous')
      test_result_has_course_ids(courses, ["previous_ACMS_10141", "previous_ACMS_10145"])
    end


    it "returns the instructors instructed courses for the current semester" do
      courses = course_api.instructed_courses('instructor', 'current')
      test_result_has_course_ids(courses, ["current_ACCT_20200"])
   end


    it "returns the instructors instructed courses for the previous semester" do
      courses = course_api.instructed_courses('instructor', 'previous')
      test_result_has_course_ids(courses, ["previous_ACCT_20100"])
    end



    describe "cross_listings" do
      it "combines the corss listed classes into one result" do
        courses = course_api.instructed_courses('instructor', 'previous')

        courses.first.cross_listings.first.id.should == "previous_ACCT_20100"
        courses.first.cross_listings.last.id.should == "previous_BAUG_20001"
      end
    end
  end

  describe :get do
    it "returns the course specified" do

    end

  end

  describe "course exceptions" do

    it "merges student exceptions into the student couse list" do
      UserCourseException.create_student_exception!('18879', semester.code, 'student')

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


  def test_result_has_course_ids(courses, valid_ids)
    courses.size.should == valid_ids.size

    courses.each do | course |
      valid_ids.include?(course.id).should be_true
    end
  end

  def display_course_ids(courses)
    puts courses.collect { | c | c.id }.inspect
  end
end
