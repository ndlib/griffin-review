require 'spec_helper'

describe InstructorTopicsForm do
  let(:user) { mock(User, :username => 'instructor') }
  let(:course_search) { CourseSearch.new }
  let(:course) { course_search.get('current_multisection_crosslisted') }
  let(:semester) { FactoryGirl.create(:semester)}

  before(:each) do
    stub_courses!

    @course = mock(Course, :id => "course_id", :title => 'title', :instructor_name => 'name', :crosslist_id => 'crosslist_id')
    @course.stub!(:semester).and_return(semester)
    @course.stub!(:reserve_id).and_return('reserve_id')

    InstructorTopicsForm.any_instance.stub(:get_course).with("course_id").and_return(@course)
  end


  it "saves the topics passed in as string" do
    reserve = mock_reserve FactoryGirl.create(:request, :available, course_id: @course.reserve_id), @course
    @course.stub(:reserve).with(reserve.id).and_return(reserve)

    params =  { course_id: @course.id, id: reserve.id, topics: "topic 1, topic 2, topic 3" }
    form = InstructorTopicsForm.new(user, params )

    form.reserve.topics.size.should == 0
    form.save_topics.should be_true
    form.reserve.topics.size.should == 3
  end


  it "saves the topics passed in as arrays" do
    reserve = mock_reserve FactoryGirl.create(:request, :available, course_id: @course.reserve_id), @course
    @course.stub(:reserve).with(reserve.id).and_return(reserve)

    params =  { course_id: @course.id, id: reserve.id, topics: "topic 1, topic 2, topic 3" }

    form = InstructorTopicsForm.new(user, params)

    form.reserve.topics.size.should == 0
    form.save_topics.should be_true
    form.reserve.topics.size.should == 3
  end


  it "changes the topics" do
    reserve = mock_reserve FactoryGirl.create(:request, :available, course_id: @course.reserve_id), @course
    @course.stub(:reserve).with(reserve.id).and_return(reserve)

    params =  { course_id: @course.id, id: reserve.id, topics: "topic 1, topic 2, topic 3" }
    form = InstructorTopicsForm.new(user, params)
    form.save_topics

    params =  { course_id: @course.id, id: reserve.id, topics: "topic 1, topic 3" }
    form = InstructorTopicsForm.new(user, params)
    form.save_topics

    form.save_topics.should be_true
    form.reserve.topics.size.should == 2
  end

  it "renders a active record not found if the reserve is missing "

  it "can tell you if the reserve has the a topic"

  it "can tell you all the available topics for the form."

end
