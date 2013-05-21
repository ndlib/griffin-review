require 'spec_helper'

describe Admin::VideoWorkflowController do

  before(:all) do
    @faculty_user_a = Factory.create(:user)
    @faculty_user_b = Factory.create(:user)
    @faculty_role = Factory.create(:faculty_role)
    @faculty_user_a.roles = [@faculty_role]
    @faculty_user_b.roles = [@faculty_role]
    @current_semester = Factory.create(:semester)
    @next_semester = Factory.create(:semester, :code => 'code1', :date_begin => Date.today + 3.months, :date_end => Date.today + 6.months)
    @distant_semester = Factory.create(:semester, :code => 'code2', :date_begin => Date.today + 7.months, :date_end => Date.today + 12.months)
    @old_semester = Factory.create(:semester, :code => 'code3', :date_begin => Date.today - 6.months, :date_end => Date.today - 2.months)
    @request_a = Factory.create(:generic_request, :semester_id => @current_semester.id, :user_id => @faculty_user_a.id)
    @request_b = Factory.create(:generic_request, :needed_by => Date.today + 4.weeks, :semester_id => @current_semester.id, :user_id => @faculty_user_b.id)
    @request_c = Factory.create(:generic_request, :needed_by => Date.today + 14.days, :semester_id => @current_semester.id, :user_id => @faculty_user_b.id)
    @media_admin_role = Factory.create(:media_admin_role)
    @media_admin_user = Factory.create(:user)
    @media_admin_user.roles = [@media_admin_role]
    @jane_user = Factory.create(:user)
  end

  before(:each) do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  context "View all video requests" do
    describe "with media admin account" do
      it "is able to view the request list" do
        sign_in @media_admin_user
        get :requests_by_state, :s_val => 'all'
        assigns(:requests).should include(@request_c)
        assigns(:requests).should have(3).requests
        sign_out @media_admin_user
      end
      it "opens full view of specific request" do
        @request_b.library_owned = true
        @request_b.save
        sign_in @media_admin_user
        get :show, :request_id => @request_b.id
        assigns(:request).should be_an_instance_of(Request)
        assigns(:request).should be_library_owned
        assigns(:request).title.should eq(@request_b.title)
        sign_out @media_admin_user
      end
      it "can see contact information for specific requester" do
        sign_in @media_admin_user
        post :requester, :user_id => @request_c.user.id
        requester_info = %({"first_name":"#{@request_c.user.first_name}", "last_name":"#{@request_c.user.last_name}"})
        response.body.should be_json_eql(requester_info)
        sign_out @media_admin_user
      end
      it "is able to view digitized requests" do
        @request_a.digitize!
        sign_in @media_admin_user
        get :requests_by_state, :s_val => 'digitized'
        assigns(:requests).should have(1).request
        sign_out @media_admin_user
      end
      it "is able to view uploaded requests" do
        @request_b.digitize!
        @request_b.upload!
        @request_a.upload!
        sign_in @media_admin_user
        get :requests_by_state, :s_val => 'uploaded'
        assigns(:requests).should have(2).request
        sign_out @media_admin_user
      end
      it "is able to view requests for a specific semester" do
        sign_in @media_admin_user
        get :requests_by_semester, :s_id => @current_semester.id
        assigns(:requests).should have(3).requests
        sign_out @media_admin_user
      end
    end
    describe "with no special privileges" do
      it "is not able to view request list" do
        sign_in @jane_user
        get :full_list
        response.should_not render_template :list
        response.should redirect_to :admin_not_authorized
        sign_out @jane_user
      end
      it "is not able to open full view for specific request" do
        sign_in @jane_user
        get :show, :request_id => @request_b.id
        response.should redirect_to :admin_not_authorized
        sign_out @jane_user
      end
    end
  end

  context "Create a new request" do
    describe "with media admin account" do
      before :each do
        sign_in @media_admin_user
      end
      after :each do
        sign_out @media_admin_user
      end
      describe "with valid data entry" do
        it "saves the request to the database" do
          expect {
            post :create, :administrative_request => Factory.attributes_for(:administrative_request, :extent => 'all', :cms => 'vista_concourse', :semester_id => @next_semester.id, :user_id => @faculty_user_a.id, :user_name => @faculty_user_a.display_name)
          }.to change(Request, :count).by(1)
        end
      end
    end
  end

  context "Modify specific request" do
    describe "with media admin account" do
      before :each do
        sign_in @media_admin_user
      end
      after :each do
        sign_out @media_admin_user
      end
      it "is able to cancel a specific request" do
        expect {
          delete :destroy, :request_id => @request_b.id
        }.to change(Request, :count).from(3).to(2)
      end
      it "is able to mark a request as digitized" do
        @request_c.digitized?.should be_false
        @request_c.workflow_state = :digitized
        @request_c.workflow_state_change_date = Time.now
        @request_c.workflow_state_change_user = @media_admin_user.id
        put :update, :request_id => @request_c.id, :request => @request_c.attributes
        get :edit, :request_id => @request_c.id
        assigns(:request).digitized?.should be_true
      end
      it "is able to mark a request as library owned" do
        @request_c.library_owned.should eq(false)
        @request_c.library_owned = true
        put :update, :request_id => @request_c.id, :request => @request_c.attributes
        get :edit, :request_id => @request_c.id
        assigns(:request).should be_library_owned
      end
      it "is able to mark a requests as a repeat request" do
        @request_c.repeat_request.should eq(false)
        @request_c.repeat_request = true
        put :update, :request_id => @request_c.id, :request => @request_c.attributes
        get :edit, :request_id => @request_c.id
        assigns(:request).should be_repeat_request
      end
      it "is able to change the title of a video" do
        @request_c.title = "TEST TITLE"
        put :update, :request_id => @request_c.id, :request => @request_c.attributes
        get :edit, :request_id => @request_c.id
        assigns(:request).title.should eq("TEST TITLE")
      end
      it "is able to change a course id for a request" do
        @request_c.course = "FA13 CHEM 101 01"
        put :update, :request_id => @request_c.id, :request => @request_c.attributes
        get :edit, :request_id => @request_c.id
        assigns(:request).course.should eq("FA13 CHEM 101 01")
      end
    end
    describe "with no special privileges" do
      before :each do
        sign_in @jane_user
      end
      after :each do
        sign_out @jane_user
      end
      it "is not able to cancel a request" do
          delete :destroy, :request_id => @request_c.id
          response.should redirect_to :admin_not_authorized
      end
      it "is not able to mark a request as converted" do
        @request_c.converted?.should be_false
        @request_c.workflow_state = :converted
        put :update, :request_id => @request_c.id, :request => @request_c.attributes
        response.should redirect_to :admin_not_authorized
      end
    end
  end

end
