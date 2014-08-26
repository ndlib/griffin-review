require 'spec_helper'

describe RequestsFixMissingCoursesController do


  before(:each) do
    ReserveSearch.any_instance.stub(:get).and_return(double(Reserve, id: 1, nd_meta_data_id: 'id'))
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


    it "redirects back to the request on error" do

      put :update, id: 1
      expect(response).to redirect_to(edit_fix_missing_course_path('1'))
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
