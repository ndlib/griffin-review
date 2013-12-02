

describe SipxRedirectController do

  describe :admin_redirect do

    before(:each) do
      @course = double(Course)
      CourseSearch.any_instance.stub(:get).and_return(@course)
      SipxRedirect.any_instance.stub(:admin_redirect_url).and_return('http://www.google.com')
    end

    it " restricts the access from students " do
      u = FactoryGirl.create(:student)
      sign_in u

      expect {
        get :admin_redirect, course_id: '1'
      }.to raise_error ActionController::RoutingError
    end

    it "restricts the access from instructors" do
      u = FactoryGirl.create(:instructor)
      sign_in u

      expect {
        get :admin_redirect, course_id: '1'
      }.to raise_error ActionController::RoutingError
    end

    it "allows access to admins" do
      u = FactoryGirl.create(:admin_user)
      sign_in u

      get :admin_redirect, course_id: '1'
      expect(response).to be_redirect
    end


    it "redirects to the url the sipx redirect provides " do
      u = FactoryGirl.create(:admin_user)
      sign_in u

      get :admin_redirect, course_id: '1'
      expect(response).to redirect_to 'http://www.google.com'
    end
  end


  describe :course_redirect do
    before(:each) do
      @url = 'http://service.sipx.com/blabla?id=23'

      ReserveSearch.any_instance.stub(:get).and_return(@reserve)
      ElectronicReservePolicy.any_instance.stub(:has_sipx_resource?).and_return(true)
      ElectronicReservePolicy.any_instance.stub(:redirect_url).and_return(@url)
    end

  end
end
