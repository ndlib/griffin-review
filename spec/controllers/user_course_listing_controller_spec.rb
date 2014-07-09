require 'spec_helper'

describe CoursesController do


  before(:each) do
    @course = double(Course, id: 'id', semester: FactoryGirl.create(:semester))
    CourseSearch.any_instance.stub(:get).and_return(@course)
  end


  describe :logged_in_as_student do

    before(:each) do
      @u = FactoryGirl.create(:student)
      sign_in @u
    end


    describe :index do

      it "returns a successful response" do
        # the failure on this does not happen when you run just this file :/
        get :index
        response.should be_success
      end


      it "passes reserves to the view" do
        get :index

        assigns(:user_course_listing).should_not be_nil
        assigns(:user_course_listing).class.should == ListUsersCourses
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
