require 'spec_helper'

describe MasqueradesController do

  before(:each) do
    u = FactoryGirl.create(:admin_user)
    sign_in u
  end


  describe :new do

    it "requires the user to be an admin" do
      Permission.any_instance.stub(:current_user_is_administrator?).and_return(true)

      get :new
      response.should be_success
    end


    it "renders a 404 if you are not an admin user" do
      Permission.any_instance.stub(:current_user_is_administrator?).and_return(false)

      lambda {
        get :new
      }.should raise_error(ActionController::RoutingError)
    end

  end


  describe :create do

    it "requires the user to be an admin" do
      Permission.any_instance.stub(:current_user_is_administrator?).and_return(true)
      masquser = FactoryGirl.create(:student)

      post :create, :username => masquser.username
      response.should be_redirect
    end


    it "renders a 404 if the user is not an admin" do
      Permission.any_instance.stub(:current_user_is_administrator?).and_return(false)

      lambda {
        post :create, :username => 'username'
      }.should raise_error(ActionController::RoutingError)
    end


    it "requires a username to be sent" do
      Permission.any_instance.stub(:current_user_is_administrator?).and_return(true)

      post :create
      response.should be_success
      response.should render_template("new")
    end


    it "fails gracefully if the username is not found." do
      Permission.any_instance.stub(:current_user_is_administrator?).and_return(true)

      post :create, :username => 'not_found_username'
      response.should be_success
      response.should render_template("new")
    end
  end
end
