require 'spec_helper'

describe UserCourseListingsController do
  let(:semester) { FactoryGirl.create(:semester) }

  before(:each) do
    semester
    stub_courses!
  end


  describe :logged_in_as_student do

    before(:each) do
      u = FactoryGirl.create(:student)
      sign_in u
    end


    describe :index do

      it "returns a successful response" do
        get :index
        response.should be_success
      end


      it "passes reserves to the view" do
        get :index

        assigns(:user_course_listing).should_not be_nil
        assigns(:user_course_listing).class.should == UserCourseListing
      end
    end


    describe :show do

      it "returns a successful response" do
        get :show, id: "current_normalclass_100"
        response.should be_success
      end


      it "passes course to the view" do
        get :show, id: "current_normalclass_100"

        assigns(:course).should_not be_nil
        assigns(:course).class.should == Course
      end


      it "returns 404 if the course is not found" do
        lambda {
          get :show, id: "current_22557-wrong"
        }.should raise_error(ActionController::RoutingError)
      end
    end
  end


  describe :logged_in_as_an_instructor do
    before(:each) do
      u = FactoryGirl.create(:instructor)
      sign_in u
    end

    describe :index do

      it "returns a successful response" do
        get :index
        response.should be_success
      end
    end


    describe :show do
      it "returns 404 if the course is not attached to the current user" do
        lambda {
          get :show, id: "current_normalclass_100"
        }.should raise_error(ActionController::RoutingError)
      end

    end
  end

end
