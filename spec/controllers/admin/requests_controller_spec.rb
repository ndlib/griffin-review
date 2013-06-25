require 'spec_helper'

describe Admin::RequestsController do

  before(:each) do
    u = FactoryGirl.create(:admin_user)
    sign_in u
  end


  it "displays the index page" do
    FactoryGirl.create(:semester)

    get :index
    response.should be_success

  end
end
