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
      test_result_has_course_ids(courses, ['20334', '22555', '22557', '21188', '20113', '24550', '25426', '28873', '29157', '28883', '21015'])
    end

    it "returns the students enrolled courses for the previous semseter" do
      courses = course_api.enrolled_courses('student', 'previous')
      test_result_has_course_ids(courses, ['11389', '12574', '12548', '18985', '12777', '14389', '11640'])
    end

    it "returns the inst_stu's enrolled courses for the current semester" do
      courses = course_api.enrolled_courses('inst_stu', 'current')
      test_result_has_course_ids(courses, ['29898'])
    end

    it "returns the inst_stu's enrolled courses for the previous semester" do
      courses = course_api.enrolled_courses('inst_stu', 'previous')

      puts "'" + courses.collect { | c | c.id }.join("', '") + "'"
      test_result_has_course_ids(courses, ['19745', '19591', '20066'])
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
      test_result_has_course_ids(courses, ['28972', '28971', '29901'])
    end


    it "returns the inst_stu's instructed courses for the previous semester" do
      courses = course_api.instructed_courses('inst_stu', 'previous')
      test_result_has_course_ids(courses, ['18446', '18448'])
    end


    it "returns the instructors instructed courses for the current semester" do
      courses = course_api.instructed_courses('instructor', 'current')
      test_result_has_course_ids(courses, ['25823', '26315'])
   end


    it "returns the instructors instructed courses for the previous semester" do
      courses = course_api.instructed_courses('instructor', 'previous')
      test_result_has_course_ids(courses, ['16398', '16402'])
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
