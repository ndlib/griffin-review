require 'spec_helper'
Reserve

describe GetReservesController do
  let(:semester) { FactoryGirl.create(:semester) }

  before(:each) do
    semester
    stub_courses!

    u = FactoryGirl.create(:student)
    sign_in u

    @course = CourseSearch.new.get("current_multisection_crosslisted")

    request = FactoryGirl.create(:request, :available, :book_chapter)
    @reserve = mock_reserve request, @course

    @url_reserve = mock_reserve FactoryGirl.create(:request, :available, :video), @course
  end

  describe :show do

    context 'requires copy right acceptance' do
      before(:each) do
        Reserve.any_instance.stub(:approval_required?).and_return(true)
      end

      it "renders the view if the course listing requires copyright acceptance" do
        get :show, id: @reserve.id, course_id: @course.id
        response.should render_template("show")
      end

      it "downloads the item if the copyright accepetance has been accepted and it is a download item" do
        controller.should_receive(:send_file).and_return{controller.render :nothing => true}

        get :show, id: @reserve.id, course_id: @course.id, accept_terms_of_service: 1
      end

      it "redirects if the copyright acceptance has has been accepted and it is a redirect item" do
        reserve = mock_reserve FactoryGirl.create(:request, :available, :journal_url), @course

        get :show, id: reserve.id, course_id: @course.id, accept_terms_of_service: 1

        response.should be_redirect
      end


      it "renders a 404 if the reserve is not in the current semester" do
        previous_course = CourseSearch.new.get("previous_multisection")
        request = FactoryGirl.create(:request, :available, :book_chapter, :previous_semester)
        previous_reserve = Reserve.factory(request, previous_course)

        lambda {
          get :show, id: previous_reserve.id, course_id: previous_course.id
        }.should raise_error ActionController::RoutingError
      end
    end


    context ' it does not requre copyright acceptance' do
      before(:each) do
        Reserve.any_instance.stub(:approval_required?).and_return(false)
      end

      it "downloads the file if it is a downloaded item " do
        controller.should_receive(:send_file).and_return{controller.render :nothing => true}

        get :show, id: @reserve.id, course_id: @course.id
      end

      it "redirects if the file is a redierect item" do
        reserve = mock_reserve FactoryGirl.create(:request, :available, :journal_url), @course

        get :show, id: reserve.id, course_id: @course.id
        response.should redirect_to(reserve.url)
      end
    end
  end

end
