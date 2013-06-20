require 'spec_helper'

describe CopyReservesController do

  let(:semester) { FactoryGirl.create(:semester) }
  let(:previous_semester) { FactoryGirl.create(:previous_semester) }

  before(:each) do
    semester
    previous_semester
    stub_courses!
  end


  describe :instructor do
    before(:each) do
      u = FactoryGirl.create(:instructor)
      sign_in u
    end

    describe :copy do

      it "returns a successful response" do
        CopyReservesController.any_instance.stub(:check_instructor_permissions!).and_return(true)

        post :copy, :course_id => "current_multisection_crosslisted", :from_course_id => "previous_multisection"
        response.should be_success
      end


      it "sets a copy_requests variable" do
        CopyReservesController.any_instance.stub(:check_instructor_permissions!).and_return(true)

        post :copy, :course_id => "current_multisection_crosslisted", :from_course_id => "previous_multisection"
        assigns(:copy_course_listing).should be_true
      end


      it "redirects to the original page if there is an error."
    end


    describe :step1 do

      it "returns a successful response " do
        CopyReservesController.any_instance.stub(:check_instructor_permissions!).and_return(true)

        get :copy_step1, :course_id => "current_multisection_crosslisted"
        response.should be_success
      end

      it "sets a copy_requests variable" do
        CopyReservesController.any_instance.stub(:check_instructor_permissions!).and_return(true)

        get :copy_step1, :course_id => "current_multisection_crosslisted"
        assigns(:copy_course_listing).should be_true
      end
    end


    describe :step2 do

      it "returns a successful response " do
        CopyReservesController.any_instance.stub(:check_instructor_permissions!).and_return(true)

        get :copy_step2, :course_id => "current_multisection_crosslisted", :from_course_id => "previous_multisection"
        response.should be_success
      end

      it "sets a copy_requests variable" do
        CopyReservesController.any_instance.stub(:check_instructor_permissions!).and_return(true)

        get :copy_step2, :course_id => "current_multisection_crosslisted", :from_course_id => "previous_multisection"
        assigns(:copy_course_listing).should be_true
      end

    end
  end

  describe :student do

    before(:each) do
      u = FactoryGirl.create(:student)
      sign_in u
    end

    describe :copy do

      it "denies students access" do
        lambda {
          post :copy, :course_id => "current_25823", :from_course_id=> "current_26315"
        }.should raise_error(ActionController::RoutingError)
      end
    end
  end


end
