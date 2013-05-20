require 'spec_helper'

describe CopyReservesController do

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

    describe :create do

      it "returns a successful response" do
        post :create, :course_id => "current_25823", :to_course => "current_26315"
        response.should be_success
      end


      it "sets a copy_requests variable" do
        post :create, :course_id => "current_25823", :to_course => "current_26315"
        assigns(:copy_course_listing).should be_true
      end


      it "redirects to the original page if there is an error."
    end
  end

  describe :student do

    before(:each) do
      u = FactoryGirl.create(:student)
      sign_in u
    end

    describe :create do

      it "denies students access" do
        lambda {
          post :create, :course_id => "current_25823", :to_course => "current_26315"
        }.should raise_error(ActionController::RoutingError)
      end
    end
  end


end
