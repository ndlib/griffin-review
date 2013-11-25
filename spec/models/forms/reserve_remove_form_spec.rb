require 'spec_helper'


describe ReserveRemoveForm do

  before(:each) do
    @course = double(Course, id: 'id')
    @reserve = double(Reserve, id: 1, course: @course)

    @controller = double(ApplicationController, params: { id: @reserve.id })

    ReserveSearch.any_instance.stub(:get).and_return(@reserve)
  end


  describe :validations do

    it "raises a routing error if the reserve is not found" do
      ReserveSearch.any_instance.stub(:get).and_raise(ActiveRecord::RecordNotFound)
      lambda {
        ReserveRemoveForm.new(@controller)
      }.should raise_error ActionController::RoutingError
    end
  end


  describe :course do

    it "returns the coures for the current reserve" do
      form = ReserveRemoveForm.new(@controller)
      expect(form.course).to eq(@course)
    end
  end


  describe :remove! do

    it "changes the state to remove when it is removed" do
      form = ReserveRemoveForm.new(@controller)

      @reserve.should_receive(:remove)
      form.remove!
    end
  end
end
