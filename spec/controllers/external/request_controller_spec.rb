require 'spec_helper'

describe External::RequestController do

  before(:all) do
    @current_semester = Factory.create(:semester, :code => 'code')
    @next_semester = Factory.create(:semester, :code => 'code1', :date_begin => Date.today + 3.months, :date_end => Date.today + 6.months)
    @distant_semester = Factory.create(:semester, :code => 'code2', :date_begin => Date.today + 7.months, :date_end => Date.today + 12.months)
    @old_semester = Factory.create(:semester, :code => 'code3', :date_begin => Date.today - 6.months, :date_end => Date.today - 2.months)
    @faculty_role = Factory.create(:faculty_role)
    @faculty_user = Factory.create(:user)
    @faculty_user.roles = [@faculty_role]
    @media_admin_role = Factory.create(:media_admin_role)
    @media_admin_user = Factory.create(:user, :roles => [@media_admin_role])
    @jane_user = Factory.create(:user)
  end

  before(:each) do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  context "Access video request page" do
    describe "with faculty account" do
      it "assigns a new request to @r" do
        sign_in @faculty_user
        get :new
        assigns(:r).should be_a_new(Request)
        sign_out @faculty_user
      end
      it "renders the new request template" do
        sign_in @faculty_user
        get :new
        response.should render_template :new
        sign_out @faculty_user
      end
    end
    describe "with a non faculty account" do
      it "gives an access denied" do
        sign_in @jane_user
        get :new
        response.should redirect_to external_not_authorized_path
        sign_out @jane_user
      end
    end
  end
end
