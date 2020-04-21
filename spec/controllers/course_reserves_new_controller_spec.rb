require 'spec_helper'

describe CourseReservesController do

  before(:each) do
    @course = double(Course, id: 'id', semester: FactoryBot.create(:semester))
    CourseSearch.any_instance.stub(:get).and_return(@course)
  end


  describe :instructor do
    before(:each) do
      u = FactoryBot.create(:instructor)
      sign_in u

      @course.stub(instructor_netids: [u.username])
    end

    describe :new do

      it "returns a successful response" do
        CourseReservesController.any_instance.stub(:check_instructor_permissions!).and_return(true)

        get :new, :course_id => "current_multisection_crosslisted"
        response.should be_success
      end


      it "sets a course variable" do
        CourseReservesController.any_instance.stub(:check_instructor_permissions!).and_return(true)

        get :new, :course_id => "current_multisection_crosslisted"
        assigns(:new_reserve).should be_truthy
      end

    end


    describe :create do

      it "redirects on a successful create" do
        InstructorReserveRequest.any_instance.stub(:make_request).and_return(true)
        CourseReservesController.any_instance.stub(:check_instructor_permissions!).and_return(true)

        post :create, :course_id => "current_multisection_crosslisted", :instructor_reserve_request => {}
        response.should be_redirect
      end


      it "renders the new action if the form is not valid" do
        InstructorReserveRequest.any_instance.stub(:make_request).and_return(false)
        CourseReservesController.any_instance.stub(:check_instructor_permissions!).and_return(true)

        post :create, :course_id => "current_multisection_crosslisted", :instructor_reserve_request => {}
        response.should render_template("new")
      end
    end
  end

  describe :student do
    before(:each) do
      u = FactoryBot.create(:student)
      sign_in u

      @course.stub(instructor_netids: [])
    end

    describe :new do

      it "denies access" do
        lambda {
          get :new, :course_id => "current_multisection_crosslisted"
        }.should render_template(nil)
      end
    end

    describe :create do
      it "denies access" do
        lambda {
          post :create, :course_id => "current_multisection_crosslisted", :instructor_reserve_request => {}
        }.should render_template(nil)
      end
    end
  end

end
