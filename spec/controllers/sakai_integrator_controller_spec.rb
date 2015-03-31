require 'spec_helper'

describe SakaiIntegratorController do
  before(:each) do
    u = FactoryGirl.create(:student, username: 'bwright6')
    sign_in u
  end
  let (:course) { double(Course, id: 'id') }

  it "uses the sakai integrator to determine the course" do
    expect(SakaiIntegrator).to receive(:call).with('context_id', 'bwright6').and_return(course)
    post :sakai_redirect, context_id: "context_id"
  end

  it "redirects to the course from the sakai integrator" do
    allow(SakaiIntegrator).to receive(:call).and_return(course)

    post :sakai_redirect, context_id: "context_id"
    expect(response.status).to eq(302)
    response.should redirect_to(sakai_course_reserves_url(course_id: course.id))
  end

  it "should redirect to /sakai/courses if course not found" do
    allow(SakaiIntegrator).to receive(:call).and_return(nil)

    post :sakai_redirect, context_id: "notfound course id"
    expect(response.status).to eq(302)
    response.should redirect_to(sakai_courses_url)
  end

end
