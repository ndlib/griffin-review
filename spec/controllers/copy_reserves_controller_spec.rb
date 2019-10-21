require 'spec_helper'

describe CopyReservesController do
  let(:previous_semester) { FactoryGirl.create(:previous_semester) }

  before(:each) do
    @to_course = double(Course, id: 'id', semester: FactoryGirl.create(:semester))
    @from_course = double(Course, id: 'id', semester: FactoryGirl.create(:previous_semester))

    CourseSearch.any_instance.stub(:get).and_return(@to_course)
    CourseSearch.any_instance.stub(:get).with(@from_course.id).and_return(@to_course)
  end


  describe :instructor do
    before(:each) do
      u = FactoryGirl.create(:instructor)
      sign_in u

      @to_course.stub(instructor_netids: [u.username])
      @from_course.stub(instructor_netids: [u.username])
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
        assigns(:copy_course_listing).should be_truthy
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
        assigns(:copy_course_listing).should be_truthy
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
        assigns(:copy_course_listing).should be_truthy
      end

    end
  end

  describe :student do

    before(:each) do
      u = FactoryGirl.create(:student)
      sign_in u

      @to_course.stub(instructor_netids: [])
      @from_course.stub(instructor_netids: [])
    end

    describe :copy do

      it "denies students access" do
        lambda {
          post :copy, :course_id => "current_25823", :from_course_id=> "current_26315"
        }.should render_template(nil)
      end
    end
  end


end
