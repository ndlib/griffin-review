require 'spec_helper'

describe CopyReserve do

  let(:semester) { FactoryGirl.create(:semester) }
  let(:course_search) { CourseSearch.new }

  before(:each) do
    stub_courses!

    FactoryGirl.create(:semester)
    FactoryGirl.create(:previous_semester)

    @from_course = course_search.get('previous_multisection')
    @to_course = course_search.get('current_multisection_crosslisted')

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
    new_reserve.course_id.should == @to_course.id
    new_reserve.crosslist_id.should == @to_course.crosslist_id
  end


  it "changes the state to new " do
    new_reserve = @copy_reserve.copy

    new_reserve.workflow_state == 'new'
  end


  it "does not copy tags" do
    @reserve.set_topics!('topic1')

    new_reserve = @copy_reserve.copy
    new_reserve.topics.should == []
  end

  it "does not copy the item" do
    new_reserve = @copy_reserve.copy
    new_reserve.item.id.should == @reserve.item.id
  end
end
