require 'spec_helper'


describe Admin::CopyOldReservesController do

  before(:each) do
    stub_courses!
    FactoryGirl.create(:semester)

    @u = FactoryGirl.create(:admin_user)
    sign_in @u

    @course = CourseSearch.new.get('current_multisection_crosslisted')
  end


  describe :new do

    it "displays the new page" do
      get :new, course_id: @course.id
      response.should be_success
    end


    it "does not allow non admins in" do
      u = FactoryGirl.create(:admin_user)
      u.revoke_admin!
      sign_in u

      lambda {
        get :new, course_id: @course.id
      }.should raise_error(ActionController::RoutingError)
    end


    it "allows an admin masquerading as a instrucotor in"
  end


  describe :create do

    it "redirects when they create the item " do
      c = mock_model(OpenCourse, reserves: [])
      OpenCourse.stub(:find).and_return(c)

      post :create, course_id: @course.id, :from_course_id => 'from_course_id'
      response.should be_redirect
    end


    it "does not allow non admins in" do
      u = FactoryGirl.create(:admin_user)
      u.revoke_admin!
      sign_in u

      lambda {
        post :create, course_id: @course.id
      }.should raise_error(ActionController::RoutingError)
    end


    it "allows an admin masquerading as a instrucotor in"
  end
end
