require 'spec_helper'

describe InstructorNewReservesController do

  let(:semester) { FactoryGirl.create(:semester) }

  before(:each) do
    semester
    stub_courses!
  end


  describe :instructor do
    before(:each) do
      u = FactoryGirl.create(:instructor)
      sign_in u
    end

    describe :new do

      it "returns a successful response" do
        get :new, :course_id => "current_25823"
        response.should be_success
      end


      it "sets a course variable" do
        get :new, :course_id => "current_25823"
        assigns(:request_reserve).should be_true
      end

    end


    describe :create do

      it "redirects on a successful create" do
        InstructorReserveRequest.any_instance.stub(:make_request).and_return(true)

        post :create, :course_id => "current_25823", :instructor_reserve_request => {}
        response.should be_redirect
      end


      it "renders the new action if the form is not valid" do
        InstructorReserveRequest.any_instance.stub(:make_request).and_return(false)

        post :create, :course_id => "current_25823", :instructor_reserve_request => {}
        response.should render_template("new")
      end
    end
  end

  describe :student do
    before(:each) do
      u = FactoryGirl.create(:student)
      sign_in u
    end

    describe :new do

      it "denies access" do
        lambda {
          get :new, :course_id => "current_25823"
        }.should raise_error(ActionController::RoutingError)
      end
    end

    describe :create do
      it "denies access" do
        lambda {
          post :create, :course_id => "current_25823", :instructor_reserve_request => {}
        }.should raise_error(ActionController::RoutingError)
      end
    end
  end

end
