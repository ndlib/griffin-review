require 'spec_helper'

describe RequestsController do

  before(:each) do
    u = FactoryGirl.create(:admin_user)
    sign_in u
  end


  describe :index do

    it "displays the index page" do
      FactoryGirl.create(:semester)

      get :index
      response.should be_success
    end


    it "does not allow non admins in" do
      u = FactoryGirl.create(:admin_user)
      u.revoke_admin!
      sign_in u

      lambda {
        get :index
        }.should render_template(nil)
    end

  end

end
