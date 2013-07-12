require 'spec_helper'


describe Admin::RequestsFairUseController do

  before(:each) do
    stub_courses!

    u = FactoryGirl.create(:admin_user)
    sign_in u

    @course = CourseSearch.new.get('current_multisection_crosslisted')
    @reserve = mock_reserve(FactoryGirl.create(:request, :book), @course)
  end


  describe :edit do

    it "displays the edit page" do
      get :edit, id: @reserve.id
      response.should be_success
    end


    it "does not allow non admins in" do
      u = FactoryGirl.create(:admin_user)
      u.revoke_admin!
      sign_in u

      lambda {
        get :edit, id: @reserve.id
      }.should raise_error(ActionController::RoutingError)
    end

  end


  describe :update do

    it "redirects when it is done" do
      put :update, id: @reserve.id
      response.should be_redirect
    end


    it "does not allow non admins in" do
      u = FactoryGirl.create(:admin_user)
      u.revoke_admin!
      sign_in u

      lambda {
        put :update, id: @reserve.id
      }.should raise_error(ActionController::RoutingError)
    end
  end
end
