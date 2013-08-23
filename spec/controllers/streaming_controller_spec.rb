require 'spec_helper'


describe StreamingController do
  let(:current_course) { '201300_3605' }
  let(:username) { 'abuchman'}
  let(:current_course_key) { "student/#{current_course}/#{username}"}
  let(:semester_code) { '201300'}

  before(:each) do
    Factory(:semester, code: semester_code)

    VCR.use_cassette current_course_key do
      @current_course = CourseSearch.new.get(current_course)
    end

    res = mock_reserve FactoryGirl.create(:request, :available, :video), @current_course

    ReserveSearch.any_instance.stub(:get).and_return(res)
    GetReserve.any_instance.stub(:get_course_token).and_return('token')
  end

  it "does not allow you to view the item if the id is not in the course id" do
    expect {
      get :show, token: 'token', id: 'id', course_id: "not course id "
    }.to raise_error ActionController::RoutingError
  end


  it "allows you in if the token is valid and there is no session " do
    get :show, token: 'token', id: 'id', course_id: @current_course.id
  end


  it "even with a valid token if we can check cas and you don't have access it will deny you" do
    turn_on_ldap!

    u = FactoryGirl.create(:student, username: 'bcarrico')
    sign_in u

    expect {
      get :show, token: 'token', id: 'id', course_id: @current_course.id
    }.to raise_error ActionController::RoutingError
  end


  it "will let you download the mov if you have a valid token and access to the class with cas" do
    turn_on_ldap!

    u = FactoryGirl.create(:student, username: username)
    login_as u

    get :show, token: 'token', id: 'id', course_id: @current_course.id
  end
end
