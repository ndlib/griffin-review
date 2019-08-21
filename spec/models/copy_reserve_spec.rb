require 'spec_helper'

describe CopyReserve do

  let(:semester) { FactoryGirl.create(:semester) }
  let(:course_search) { CourseSearch.new }
  let(:user) { User.new(id: 1, username: 'bobbobbers')}

  before(:each) do
    @current_semester = FactoryGirl.create(:semester)
    @from_course = double(Course, id: 'from_id', semester: @current_semester)
    @to_course = double(Course, id: 'to_id', semester: FactoryGirl.create(:previous_semester))

    @reserve = Reserve.factory(FactoryGirl.create(:request, :available), @from_course)

    @copy_reserve = CopyReserve.new(user, @to_course, @reserve)

    CourseSearch.any_instance.stub(:get).and_return(@to_course)
  end


  it "makes a copy of the request" do
    new_reserve = @copy_reserve.copy
    new_reserve.id.should_not == @reserve.id
  end


  it "changes the semester to the one for the course" do
    new_reserve = @copy_reserve.copy
    new_reserve.semester.should == @to_course.semester
  end


  it "sets the copyied reserve to not be found in aleph if the semesters are different" do
    @reserve.currently_in_aleph = true
    @reserve.save!

    expect(@copy_reserve.copy.currently_in_aleph).to be_falsey
  end

  it "changes the course to the new course" do
    new_reserve = @copy_reserve.copy

    new_reserve.course_id.should == @to_course.id
  end

  it "copies the currently_in_aleph flag if the course is in the same semester as the old request" do
    to_course = double(Course, id: 'to_id', semester: @current_semester)
    @reserve.currently_in_aleph = true
    @copy_reserve = CopyReserve.new(user, to_course, @reserve)

    expect(@copy_reserve.copy.currently_in_aleph).to be_truthy
  end

  it "changes the state to new " do
    new_reserve = @copy_reserve.copy

    new_reserve.workflow_state == 'new'
  end


  it "does not copy the item" do
    new_reserve = @copy_reserve.copy
    new_reserve.item.id.should == @reserve.item.id
  end


  it "sets the requestor id of the person coping the item" do
    new_reserve = @copy_reserve.copy
    expect(new_reserve.requestor_netid).to eq("bobbobbers")
  end

  it "resets the created at and updated at" do
    @reserve.request.created_at = 6.days.ago

    @copy_reserve = CopyReserve.new(user, @to_course, @reserve)

    new_reserve = @copy_reserve.copy
    expect(new_reserve.created_at.to_s ).to eq(Time.now.to_s)
  end


  it "resets the needed by to be nil (not entered) " do
    @reserve.request.created_at = 6.days.ago

    @copy_reserve = CopyReserve.new(user, @to_course, @reserve)

    new_reserve = @copy_reserve.copy
    expect(new_reserve.needed_by ).to eq(2.weeks.from_now.to_date)
  end


  it "checks if the new reserve is complete" do
    ReserveCheckIsComplete.any_instance.should_receive(:check!)
    @copy_reserve.copy
  end
end
