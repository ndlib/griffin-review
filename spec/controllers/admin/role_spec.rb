require 'spec_helper'

describe Admin::RoleController do

  before(:all) do
    @reserves_admin_role = Factory.create(:reserves_admin_role)
    @reserves_admin_user = Factory.create(:user)
    @reserves_admin_user.roles = [@reserves_admin_role]
    @admin_role = Factory.create(:admin_role)
    @admin_user = Factory.create(:user)
    @admin_user.roles = [@admin_role]
    @media_admin_role = Factory.create(:media_admin_role)
    @media_admin_user = Factory.create(:user)
    @media_admin_user.roles = [@media_admin_role]
    @jane_user = Factory.create(:user)
  end

  before(:each) do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  context "View, edit and delete video items" do
    describe "with admin account" do

      before(:each) do
        sign_in @admin_user
      end

      after(:each) do
        sign_out @admin_user
      end

      it "shows a list of all roles in the system" do
        get :index
        assigns(:roles).should have(3).items
      end
      it "renders the :new template" do
        get :new
        response.should render_template :new
      end
      it "saves the metadata attribute to the database" do
        expect {
          post :create, :role => { :name => 'TEST ROLE', :description => 'TEST DESC' }
        }.to change(Role, :count).by(1)
      end
      it "redirect to the full list of roles" do
        post :create, :role => { :name => 'TEST ROLE', :description => 'TEST DESC' }
        response.should redirect_to admin_role_path(Role.last.id)
      end
    end
  end

end
