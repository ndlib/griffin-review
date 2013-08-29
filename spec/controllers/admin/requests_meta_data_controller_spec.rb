require 'spec_helper'

describe RequestsMetaDataController do

  before(:each) do
    stub_discovery!

    @course = double(Course, id: 'id', semester: FactoryGirl.create(:semester))
    CourseSearch.any_instance.stub(:get).and_return(@course)

    @reserve = mock_reserve FactoryGirl.create(:request), @course

    u = FactoryGirl.create(:admin_user)
    sign_in u
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
      put :update, id: @reserve.id, admin_update_meta_data: {nd_meta_data_id: 'id'}
      response.should be_redirect
    end


    it "does not allow non admins in" do
      u = FactoryGirl.create(:admin_user)
      u.revoke_admin!
      sign_in u

      lambda {
        put :update, id: @reserve.id, admin_update_meta_data: {}
      }.should raise_error(ActionController::RoutingError)
    end

  end

end
