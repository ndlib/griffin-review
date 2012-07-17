require 'spec_helper'

describe External::RequestController do

  login_user

  render_views

  it "should make a request" do
    get :new
    assigns(:r).should be_a_new(Request)
  end

end
