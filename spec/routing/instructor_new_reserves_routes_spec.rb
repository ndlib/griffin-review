require 'spec_helper'

describe 'instructor_new_reserves' do

  it "should  route to the create " do
    { :post => "/courses/course_id/reserves" }.should route_to(
      action: "create", controller: "instructor_new_reserves", course_id: "course_id"
    )
  end


  it "should route to the new " do
    { :get => "/courses/course_id/reserves/new" }.should  route_to(
      action: "new", controller: "instructor_new_reserves", course_id: "course_id"
    )
  end


  it "should not route to the show" do
    { :get => "/courses/course_id/reserves/id" }.should_not be_routable
  end


  it "should route to the index" do
    { :get => "/courses/course_id/reserves" }.should_not be_routable
  end


  it "should not route to the destroy" do
    { :delete => "/courses/course_id/reserves/id" }.should_not be_routable
  end


  it "should route to the edit" do
    { :get => "/courses/course_id/reserves/id/edit" }.should_not be_routable
  end


  it "should not route the update" do
    { :put => "/courses/course_id/reserves/id" }.should_not be_routable
  end

end
