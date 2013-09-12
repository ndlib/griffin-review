require 'spec_helper'

describe SakaiIntegratorController do

  it "redirects to the proper crosslisted course page" do
    u = FactoryGirl.create(:student, username: 'bwright6')
    sign_in u
    VCR.use_cassette 'sakai/sakai_integrator_controller_crosslist' do
      post :sakai_redirect, context_id: "21590942-4d68-4f83-8529-da22ea02fd0e"
      expect(response.status).to eq(302)
      response.should redirect_to(sakai_course_reserves_url(course_id: '201300_33'))
    end
  end
  
  it "should redirect to /sakai/courses if course not found" do
    u = FactoryGirl.create(:student, username: 'bwright6')
    sign_in u
    VCR.use_cassette 'sakai/sakai_integrator_controller_crosslist_error' do
      post :sakai_redirect, context_id: "1590942-4d68-4f83-8529-da22ea02fd0e"
      expect(response.status).to eq(302)
      response.should redirect_to(sakai_courses_url)
    end
  end

end
