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
      test_result_has_course_ids(courses, ['current_20334', 'current_22555', 'current_22557', 'current_21188', 'current_20113', 'current_24550', 'current_25426', 'current_28873', 'current_29157', 'current_28883', 'current_21015'])
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

      puts "'" + courses.collect { | c | c.id }.join("', '") + "'"
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
      test_result_has_course_ids(courses, ['current_28972', 'current_28971', 'current_29901'])
    end


    it "returns the inst_stu's instructed courses for the previous semester" do
      courses = course_api.instructed_courses('inst_stu', 'previous')
      puts courses.collect { | c | c.id}
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
