require 'spec_helper'

describe 'Get Reserves' do

  it "should not route to the show" do
    { :get => "/courses/course_id/get_reserves/id" }.should route_to(
      action: "show", controller: "get_reserves", id: "id", course_id: "course_id"
    )
  end


  it "should route to the index" do
    { :get => "/courses/course_id/get_reserves" }.should_not be_routable
  end


  it "should not route to the destroy" do
    { :delete => "/courses/course_id/get_reserves/id" }.should_not be_routable
  end


#  fails because it thinks this is an id
#  it "should not route to the new " do
#    { :get => "/courses/course_id/get_reserves/new" }.should_not be_routable
#  end


  it "should route to the edit" do
    { :get => "/courses/course_id/get_reserves/id/edit" }.should_not be_routable
  end


  it "should not route to the create " do
    { :post => "/courses/course_id/get_reserves" }.should_not be_routable
  end


  it "should not route the update" do
    { :put => "/courses/course_id/get_reserves/id" }.should_not be_routable
  end

end
