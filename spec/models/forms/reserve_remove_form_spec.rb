require 'spec_helper'


describe ReserveRemoveForm do

  let(:user) { mock_model(User, id: 1, username: 'username')}

  before(:each) do
    semester = FactoryGirl.create(:semester)
    @course = double(Course, id: 'id', crosslist_id: 'crosslist_id', semester: semester)

  end


  describe :validations do

    it "raises a routing error if the course is not found" do
      CourseSearch.any_instance.stub(:get).and_return(nil)
      lambda {
        ReserveRemoveForm.new(user, { course_id: 'not_a_course_id', id: 1 })
      }.should raise_error ActionController::RoutingError
    end


    it "raises a routing error if there is no reserve" do
      CourseSearch.any_instance.stub(:get).and_return(@course)

      lambda {
        ReserveRemoveForm.new(user, { course_id: 'course_id', id: 1231231 })
      }.should raise_error ActionController::RoutingError
    end

  end


  describe :remove! do

    it "changes the state to remove when it is removed" do
      CourseSearch.any_instance.stub(:get).and_return(@course)
      reserve = mock_reserve FactoryGirl.create(:request), @course

      form = ReserveRemoveForm.new(user, { course_id: 'course_id', id: reserve.id })

      form.remove!

      reserve.request.reload
      reserve.workflow_state.should == "removed"
    end

  end

end
