require 'spec_helper'

describe Admin::GroupController do

  before(:all) do
    @admin_role = Factory.create(:admin_role)
    @jane_user = Factory.create(:user)
    @admin_user = Factory.create(:user)
  end

  after(:all) do
    @jane_user.destroy
    @admin_user.destroy
    @admin_role.destroy
  end

  before(:each) do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  describe "GET index" do
      
    before(:all) do 
      @admin_user.roles = [@admin_role]
      @group_a = Factory.create(:group)
    end

    after(:all) do
      @group_a.destroy
    end

    it "creates new group and assigns all groups to @groups" do
      sign_in @admin_user
      get :index
      assigns(:groups).should include(@group_a)
      sign_out @admin_user
    end
  end

end
