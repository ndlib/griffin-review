require 'spec_helper'

describe InstructedCourse do

  let(:username) { 'instructor' }
  let(:semester_code) { FactoryGirl.create(:semester).code }
  let(:course_api) { CourseApi.new }

  before(:each) do
    stub_courses!
    @course = course_api.get(username, "current_ACCT_20200")
  end


  it "has all the sections the instructor teaches in it " do
    @course.section.size.should == 4
  end


  it "merges all the sections together for the net ids call" do
    total_size = @course.section.collect{ | s | s['enrollments']}.flatten.size
    @course.student_netids.size.should == total_size
  end


  it " returns the first instructor in the sections name" do
    @course.instructor_name.should == "wschmuhl"
  end


  it "returns only the first sections list of instructors (this may be a defect)"


  it "returns the term code " do
    @course.term_code.should == "current"
  end


  it "returns an array with all the sections numbers of all the sections." do
    @course.section_number.should == [1, 2, 6, 9]
  end

end
