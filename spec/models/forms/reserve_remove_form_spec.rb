require 'spec_helper'


describe ReserveRemoveForm do

  let(:user) { mock_model(User, id: 1, username: 'username')}

  before(:each) do
    semester = FactoryGirl.create(:semester)
    @course = double(Course, id: 'id', crosslist_id: 'crosslist_id', semester: semester)
    @reserve = double(Reserve, id: 1, course: @course)

    ReserveSearch.any_instance.stub(:get).and_return(@reserve)
  end


  describe :validations do

    it "raises a routing error if the reserve is not found" do
      ReserveSearch.any_instance.stub(:get).and_raise(ActiveRecord::RecordNotFound)
      lambda {
        ReserveRemoveForm.new(user, { course_id: 'course_id', id: '324234' })
      }.should raise_error ActionController::RoutingError
    end
  end


  describe :course do

    it "returns the coures for the current reserve" do
      form = ReserveRemoveForm.new(user, { course_id: 'course_id', id: @reserve.id })
      expect(form.course).to eq(@course)
    end
  end


  describe :remove! do

    it "changes the state to remove when it is removed" do
      form = ReserveRemoveForm.new(user, { course_id: 'course_id', id: @reserve.id })

      @reserve.should_receive(:remove)
      form.remove!
    end
  end
end
