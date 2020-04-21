require 'spec_helper'

describe CourseReservesController do

  before(:each) do
    @course = double(Course, id: 'id', semester: FactoryBot.create(:semester))
    @reserve = double(Reserve, id: 1, course: @course, title: "title")

    ReserveSearch.any_instance.stub(:get).and_return(@reserve)
  end


  describe :instructor do
    before(:each) do
      u = FactoryBot.create(:instructor)
      sign_in u
    end

    describe :destroy do

      context "the instructor has permission" do
        before(:each) do
          CourseReservesController.any_instance.stub(:check_instructor_permissions!).and_return(true)
        end

        it "returns a successful response" do
          ReserveRemoveForm.any_instance.should_receive(:remove!)

          delete :destroy, course_id: @course.id, id: @reserve.id

          expect(response).to be_redirect
          expect(response).to redirect_to(course_reserves_url(@course.id))
        end


        it "calls the destroy method" do
          ReserveRemoveForm.any_instance.should_receive(:remove!)
          delete :destroy, course_id: @course.id, id: @reserve.id
        end


        it "redirects to the admin if it is indicated to do so" do
          ReserveRemoveForm.any_instance.should_receive(:remove!)

          delete :destroy, course_id: @course.id, id: @reserve.id, redirect_to: 'admin'

          expect(response).to be_redirect
          expect(response).to redirect_to(request_url(@reserve.id))
        end
      end


      context "the instructor does not have permission " do
        before(:each) do
          CourseReservesController.any_instance.stub(:check_instructor_permissions!).and_raise(ActionController::RoutingError.new("404"))
        end

        it "calls the destroy method" do
          expect {
            delete :destroy, course_id: @course.id, id: @reserve.id
          }.to raise_error ActionController::RoutingError
        end
      end
    end
  end


  describe :student do
    before(:each) do
      u = FactoryBot.create(:student)
      sign_in u

      CourseReservesController.any_instance.stub(:check_instructor_permissions!).and_raise(ActionController::RoutingError.new("404"))
    end

    it "calls the destroy method" do
      expect {
        delete :destroy, course_id: @course.id, id: @reserve.id
      }.to raise_error ActionController::RoutingError
    end
  end

end
