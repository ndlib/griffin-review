require 'spec_helper'

describe RequestsFixMissingCoursesController do


  before(:each) do
    ReserveSearch.any_instance.stub(:get).and_return(double(Reserve, id: 1, nd_meta_data_id: 'id', course_id: 'old_course_id', course: double(Course, id: 'old_course_id')))
    CourseSearch.any_instance.stub(:get).and_return(double(Course, id: 'new_course_id'))
  end


  describe :admin do
    before(:each) do
      u = FactoryGirl.create(:admin_user)
      sign_in u

      described_class.any_instance.stub(:check_admin_permission!).and_return(true)
    end


    it "redirects back to the request on success" do

      put :update, id: 1
      expect(response).to redirect_to(request_path('1'))
    end


    it "renders edit on error" do
      RequestFixMissingCourseForm.any_instance.stub(:update_course_id!).and_return(false)
      put :update, id: 1
      expect(response).to be_success
    end

    it "displays the edit page" do
      get :edit, id: 1

      expect(response).to be_success
    end
  end


  describe :not_admin do
    before(:each) do
      u = FactoryGirl.create(:instructor)
      sign_in u

      described_class.any_instance.stub(:check_admin_permission!).and_raise(ActionController::RoutingError.new("error"))
    end

    it "404s" do
      expect {
        put :update, id: 1
      }.to raise_error(ActionController::RoutingError)
    end
  end
end
