require 'spec_helper'

describe SakaiIntegratorController do
  before(:each) do
    u = FactoryGirl.create(:student, username: 'bwright6')
    sign_in u
  end

  it "redirects to the proper crosslisted course page" do
    SakaiIntegratorController.any_instance.stub(:sakai_callback).and_return('201300_33')

    post :sakai_redirect, context_id: "21590942-4d68-4f83-8529-da22ea02fd0e", lis_person_sourcedid: "bwright6"
    expect(response.status).to eq(302)
    response.should redirect_to(sakai_course_reserves_url(course_id: '201300_33'))
  end

  it "should redirect to /sakai/courses if course not found" do
    SakaiIntegrator
    SakaiIntegratorController.any_instance.stub(:sakai_callback).and_return(nil)

    post :sakai_redirect, context_id: "1590942-4d68-4f83-8529-da22ea02fd0e", lis_person_sourcedid: "bwright6"
    expect(response.status).to eq(302)
    response.should redirect_to(sakai_courses_url)
  end

end
