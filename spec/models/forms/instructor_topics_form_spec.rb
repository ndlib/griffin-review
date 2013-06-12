require 'spec_helper'

describe InstructorTopicsForm do
  let(:user) { mock(User, :username => 'instructor') }
  let(:course_search) { CourseSearch.new }
  let(:course) { course_search.get('current_multisection_crosslisted') }

  before(:each) do
    stub_courses!
  end

  it "saves the topics passed in as string" do
    reserve = mock_reserve FactoryGirl.create(:request, :available, course_id: course.reserve_id), course
    form = InstructorTopicsForm.new(user, reserve, { topics: "topic 1, topic 2, topic 3" })

    form.reserve.topics.size.should == 0
    form.save_topics.should be_true
    form.reserve.topics.size.should == 3
  end


  it "saves the topics passed in as arrays" do
    reserve = mock_reserve FactoryGirl.create(:request, :available, course_id: course.reserve_id), course
    form = InstructorTopicsForm.new(user, reserve, { topics: ["topic 1", "topic 2", "topic 3"] })

    form.reserve.topics.size.should == 0
    form.save_topics.should be_true
    form.reserve.topics.size.should == 3

  end


  it "changes the topics" do
    reserve = mock_reserve FactoryGirl.create(:request, :available, course_id: course.reserve_id), course
    form = InstructorTopicsForm.new(user, reserve, { topics: "topic 1, topic 2, topic 3" })
    form.save_topics

    form = InstructorTopicsForm.new(user, reserve, { topics: "topic 1, topic 3" })
    form.save_topics

    form.save_topics.should be_true
    form.reserve.topics.size.should == 2
  end


  it "can tell you if the reserve has the a topic"

  it "can tell you all the available topics for the form."

end
