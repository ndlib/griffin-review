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
  end

end
