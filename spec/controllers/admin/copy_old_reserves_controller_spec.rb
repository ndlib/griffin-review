require 'spec_helper'


describe CopyOldReservesController do

  before(:each) do
    @u = FactoryGirl.create(:admin_user)
    sign_in @u

    @course = double(Course, id: 'id', semester: FactoryGirl.create(:semester))
    CourseSearch.any_instance.stub(:get).and_return(@course)
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
      }.should render_template(nil)
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
      }.should render_template(nil)
    end


    it "allows an admin masquerading as a instrucotor in"
  end
end
