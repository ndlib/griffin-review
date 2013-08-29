require 'spec_helper'

describe CopyReserve do

  let(:semester) { FactoryGirl.create(:semester) }
  let(:course_search) { CourseSearch.new }
  let(:user) { mock_model(User, id: 1 )}

  before(:each) do

    @from_course = double(Course, id: 'id', semester: FactoryGirl.create(:semester))
    @to_course = double(Course, id: 'id', semester: FactoryGirl.create(:previous_semester))

    @reserve = Reserve.factory(FactoryGirl.create(:request, :available), @from_course)

    @copy_reserve = CopyReserve.new(user, @to_course, @reserve)
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

    new_reserve.course_id.should == @to_course.id
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
