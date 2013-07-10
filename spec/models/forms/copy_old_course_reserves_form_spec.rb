require 'spec_helper'

describe CopyCourseReservesForm do
  let(:user) { mock_model(User, :id => 1, :username => 'instructor') }

  before(:each) do
    to_course = mock(Course, id: 'course_id', semester: FactoryGirl.create(:semester))
    from_course = mock(OpenCourse, id: 'from_course_id')

    CopyOldCourseReservesForm.any_instance.stub(:get_course).and_return(nil)
    CopyOldCourseReservesForm.any_instance.stub(:get_course).with('course_id').and_return(to_course)

    OpenCourse.any_instance.stub(:find).and_return(nil)
    OpenCourse.any_instance.stub(:find).with('from_course_id').and_return(to_course)
  end


  describe :validations do

    it "sends a 404 if the from_course is not found" do
      valid_params = { course_id: 'course_id', from_course_id: 'not_a_course_id' }

      lambda {
        CopyOldCourseReservesForm.new(user, valid_params)
      }.should raise_error ActionController::RoutingError
    end


    it "sends a 404 if the to_course is not found" do
      valid_params = { course_id: 'not_a_course_id', from_course_id: 'from_course_id' }

      lambda {
        CopyOldCourseReservesForm.new(user, valid_params)
      }.should raise_error ActionController::RoutingError
    end

  end


end
