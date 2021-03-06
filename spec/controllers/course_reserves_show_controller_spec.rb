require 'spec_helper'
Reserve

describe CourseReservesController do

  before(:each) do
    @user = FactoryBot.create(:student)
    sign_in @user

    @course = double(Course, id: 'id', semester: FactoryBot.create(:semester), title: 'Title', instructor_netids: [],  enrollment_netids: [@user.username] )

    request = FactoryBot.create(:request, :available, :book_chapter)
    @reserve = mock_reserve request, @course
    Reserve.any_instance.stub(:course).and_return(@course)

    @url_reserve = mock_reserve FactoryBot.create(:request, :available, :video), @course
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
        reserve = mock_reserve FactoryBot.create(:request, :available, :journal_url), @course

        get :show, id: reserve.id, course_id: @course.id, accept_terms_of_service: 1

        response.should be_redirect
      end


      it "renders a 404 if the reserve is not in the current semester" do
        request = FactoryBot.create(:request, :available, :book_chapter, :previous_semester)
        previous_course = double(Course, id: 'id', semester: request.semester, title: 'Title', instructor_netids: [],  enrollment_netids: [@user.username] )

        previous_reserve = Reserve.factory(request, previous_course)

        lambda {
          get :show, id: previous_reserve.id, course_id: previous_course.id
        }.should render_template(nil)
      end
    end


    context ' it does not requre copyright acceptance' do
      before(:each) do
        GetReserve.any_instance.stub(:reserve_requires_approval?).and_return(false)
      end

      it "downloads the file if it is a downloaded item " do
        controller.should_receive(:send_file).and_return{controller.render :nothing => true}

        get :show, id: @reserve.id, course_id: @course.id
      end

      it "redirects if the file is a redierect item" do
        reserve = mock_reserve FactoryBot.create(:request, :available, :journal_url), @course

        get :show, id: reserve.id, course_id: @course.id
        response.should redirect_to(reserve.url)
      end
    end
  end

end
