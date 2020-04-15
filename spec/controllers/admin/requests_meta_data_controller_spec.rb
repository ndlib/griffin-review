require 'spec_helper'

describe RequestsMetaDataController do

  before(:each) do
    stub_discovery!

    @course = double(Course, id: 'id', semester: FactoryBot.create(:semester))
    CourseSearch.any_instance.stub(:get).and_return(@course)

    @reserve = mock_reserve FactoryBot.create(:request), @course

    u = FactoryBot.create(:admin_user)
    sign_in u
  end


  describe :edit do

    it "displays the edit page" do
      get :edit, id: @reserve.id
      response.should be_success
    end


    it "does not allow non admins in" do
      u = FactoryBot.create(:admin_user)
      u.revoke_admin!
      sign_in u

      lambda {
        get :edit, id: @reserve.id
      }.should render_template(nil)
    end

  end


  describe :update do

    it "redirects when it is done" do
      AdminUpdateMetaData.any_instance.stub(:requires_nd_meta_data_id?).and_return(false)
      put :update, id: @reserve.id, admin_update_meta_data: {nd_meta_data_id: 'id'}

      response.should be_redirect
    end


    it "does not allow non admins in" do
      u = FactoryBot.create(:admin_user)
      u.revoke_admin!
      sign_in u

      lambda {
        put :update, id: @reserve.id, admin_update_meta_data: {}
      }.should render_template(nil)
    end

  end

end
