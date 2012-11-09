require 'spec_helper'

describe External::RequestController do

  before(:all) do
    @current_semester = Factory.create(:semester)
    @next_semester = Factory.create(:semester, :date_begin => Date.today + 3.months, :date_end => Date.today + 6.months)
    @distant_semester = Factory.create(:semester, :date_begin => Date.today + 7.months, :date_end => Date.today + 12.months)
    @old_semester = Factory.create(:semester, :date_begin => Date.today - 6.months, :date_end => Date.today - 2.months)
    @faculty_role = Factory.create(:faculty_role)
    @faculty_user = Factory.create(:user)
    @faculty_user.roles = [@faculty_role]
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

  context "Submit a video request" do
    describe "with faculty account" do
      describe "with valid data entry" do
        it "saves the request to the database" do
          sign_in @faculty_user
          expect {
            post :create, :request => Factory.attributes_for(:generic_request, :semester_id => @next_semester.id)
          }.to change(Request, :count).by(1)
          sign_out @faculty_user
        end
        it "redirects to thank you page" do
          sign_in @faculty_user
          post :create, :request => Factory.attributes_for(:generic_request, :semester_id => @next_semester.id)
          @last_request = Request.last
          response.should redirect_to video_request_status_path(@last_request)
          sign_out @faculty_user
        end
        it "creates a status page for their request" do
          sign_in @faculty_user
          post :create, :request => Factory.attributes_for(:generic_request, :semester_id => @next_semester.id)
          @last_request = Request.last
          get :video_request_status, {:r_id => @last_request.id}
          response.should render_template("status")
          sign_out @faculty_user
        end
      end
      describe "with invalid data entry" do
        it "does not save the record" do
          sign_in @faculty_user
          expect {
            post :create, :request => 
                  Factory.attributes_for(
                    :generic_request, 
                    { :course => "Bus 101" }
                  )
          }.to_not change(Request, :count).by(1)
          sign_out @faculty_user
        end
        it "re-renders the new request page" do
          sign_in @faculty_user
          post :create, :request => Factory.attributes_for(
                                      :generic_request, 
                                      { :course => "Bus 101" }
                                    )
          response.should render_template("new")
          sign_out @faculty_user
        end
      end
    end
  end

  context "When submitting multiple simultaneous video requests" do
    describe "and the requester submits multiple video requests for one semester" do
      it "saves the initial video request" do
          sign_in @faculty_user
          @request_a = Factory.create(:generic_request, :semester_id => @next_semester.id, :user => @faculty_user)
          @request_b = Factory.create(:generic_request, :semester_id => @next_semester.id, :user => @faculty_user)
          expect {
            post :create, :request => Factory.attributes_for(:generic_request, :semester_id => @next_semester.id), :final_multiple => true, :previous => [@request_a.id, @request_b.id]
          }.to change(Request, :count).by(1)
          sign_out @faculty_user
      end
      it "redirects back to the request form if request invalid" do
          sign_in @faculty_user
          @request_a = Factory.create(:generic_request, :semester_id => @next_semester.id, :user => @faculty_user)
          @request_b = Factory.create(:generic_request, :semester_id => @next_semester.id, :user => @faculty_user)
          post :create, :request => Factory.attributes_for(:generic_request, :course => "Bus 101", :semester_id => @next_semester.id), :final_multiple => true, :previous => [@request_a.id, @request_b.id]
          response.should render_template("new")
          sign_out @faculty_user
      end
      it "rejects a subsequent request if invalid but retains the valid records" do
          sign_in @faculty_user
          @request_a = Factory.create(:generic_request, :semester_id => @next_semester.id, :user => @faculty_user)
          @request_b = Factory.create(:generic_request, :semester_id => @next_semester.id, :user => @faculty_user)
          post :create, :request => Factory.attributes_for(:generic_request, :course => "Bus 101", :semester_id => @next_semester.id), :final_multiple => true, :previous => [@request_a.id, @request_b.id]
          response.should render_template("new")
          sign_out @faculty_user
      end
      it "renders a status page with all of their requests" do
          sign_in @faculty_user
          @request_a = Factory.create(:generic_request, :semester_id => @next_semester.id, :user => @faculty_user)
          @request_b = Factory.create(:generic_request, :semester_id => @next_semester.id, :user => @faculty_user)
          post :create, :request => Factory.attributes_for(:generic_request, :course => "Bus 101", :semester_id => @next_semester.id), :final_multiple => true, :previous => [@request_a.id, @request_b.id]
          response.should render_template("new")
          assigns(:multiple_previous).should have(2).items
          sign_out @faculty_user
      end
    end
  end
end
