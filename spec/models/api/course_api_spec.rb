require 'spec_helper'

describe CourseApi do

  let(:course_api) { CourseApi.new }

  before(:each) do
    stub_courses!
  end


  describe "api_access" do
    it "only calls the api once for enrolled and instucted courses per netid and semster"
  end


  describe "#enrolled_courses" do

    it "returns the students enrolled courses for the current semseter" do
      courses = course_api.enrolled_courses('student', 'current')
      test_result_has_course_ids(courses, ['current_20334', 'current_22555', 'current_22557', 'current_21188', 'current_20113', 'current_24550', 'current_25426', 'current_28873', 'current_29157', 'current_21015'])
    end

    it "returns the students enrolled courses for the previous semseter" do
      courses = course_api.enrolled_courses('student', 'previous')
      test_result_has_course_ids(courses, ['previous_11389', 'previous_12574', 'previous_12548', 'previous_18985', 'previous_12777', 'previous_14389', 'previous_11640'])
    end

    it "returns the inst_stu's enrolled courses for the current semester" do
      courses = course_api.enrolled_courses('inst_stu', 'current')
      test_result_has_course_ids(courses, ['current_29898'])
    end

    it "returns the inst_stu's enrolled courses for the previous semester" do
      courses = course_api.enrolled_courses('inst_stu', 'previous')
      test_result_has_course_ids(courses, ['previous_19745', 'previous_19591', 'previous_20066'])
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
      test_result_has_course_ids(courses, ['current_28969', 'current_28972', 'current_29901'])
    end


    it "returns the inst_stu's instructed courses for the previous semester" do
      courses = course_api.instructed_courses('inst_stu', 'previous')
      test_result_has_course_ids(courses, ['previous_18446', 'previous_18448'])
    end


    it "returns the instructors instructed courses for the current semester" do
      courses = course_api.instructed_courses('instructor', 'current')
      test_result_has_course_ids(courses, ['current_25823', 'current_26315'])
   end


    it "returns the instructors instructed courses for the previous semester" do
      courses = course_api.instructed_courses('instructor', 'previous')
      test_result_has_course_ids(courses, ['previous_16398', 'previous_16402'])
    end


    describe "supersections" do

      it "combines supersections into one course in the result" do
        #courses = course_api.instructed_courses('supersections', 'current')
        #courses.size.should == 6
        #courses[4].has_supersection?.should be_true
      end

    end


    describe "cross_listings" do
      it "combines the corss listed classes into one result" do
        #courses = course_api.instructed_courses('crosslisting', 'current')
        #courses.size.should == 1
        #courses.first.cross_listings.first.title.should == "current_BAUG_20001"

        #course = course_api.get(courses.first.cross_listings.first.id, 'crosslisting')
        #course.cross_listings.first.title.should == courses.first.title
      end

    end
  end


  describe "get" do
    describe "supersections" do

      it "returns all the supersection sections associated with the course" do
        #course = course_api.get('supersections', 'current_29781')
        #course.supersection_course_ids.should == ["current_29781", "current_29780", "current_29782", "current_29783"]
      end
    end


    describe "cross_listings" do
      it "returns the classes cross listed with the course" do

      end
    end
  end


  def stub_courses!
    API::Person.stub!(:courses) do  | netid, semester |
      path = File.join(Rails.root, "spec/fixtures/json_save/", "#{netid}_#{semester}.json")
      file = File.open(path, "rb")
      contents = file.read

      ActiveSupport::JSON.decode(contents)["people"].first
    end
  end


  def test_result_has_course_ids(courses, valid_ids)
    courses.size.should == valid_ids.size

    courses.each do | course |
      valid_ids.include?(course.id).should be_true
    end
  end
end
