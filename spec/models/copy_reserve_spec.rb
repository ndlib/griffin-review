require 'spec_helper'

describe CopyReserve do

  let(:semester) { FactoryGirl.create(:semester) }
  let(:course_api) { CourseApi.new }

  before(:each) do
    stub_courses!

    FactoryGirl.create(:semester)
    FactoryGirl.create(:previous_semester)

    @from_course = course_api.get('student', 'previous_ACCT_20200')
    @to_course = course_api.get('student', 'current_normalclass_100')

    @reserve = Reserve.factory(FactoryGirl.create(:request, :available), @from_course)

    @copy_reserve = CopyReserve.new(@to_course, @reserve)
  end

  it "makes a copy of the request" do

    new_reserve = @copy_reserve.copy
    new_reserve.id.should_not == @reserve.id
  end


  it "changes the semester to the one for the course" do
    new_reserve = @copy_reserve.copy
    new_reserve.semester.should == @to_course.semester
  end


  it "changes the course to the new course" do
    new_reserve = @copy_reserve.copy
    new_reserve.course.should == @to_course
  end

end
