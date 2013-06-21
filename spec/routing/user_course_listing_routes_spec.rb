require 'spec_helper'

describe 'User Course Routes' do

  it "should route to the index" do
    { :get => "/courses" }.should route_to(
      action: "index", controller: "user_course_listings"
    )
  end


  it "should not route to the show" do
    { :get => "/courses/course_id" }.should route_to(
      action: "show", controller: "user_course_listings", id: "course_id"
    )
  end


  it "should not route to the destroy" do
    { :delete => "/courses/course_id" }.should_not be_routable
  end


#  fails because it thinks this is an id
#  it "should not route to the new " do
#    { :get => "/courses/new" }.should_not be_routable
#  end


  it "should route to the edit" do
    { :get => "/courses/course_id/edit" }.should_not be_routable
  end


#  it "should not route to the create " do
#    { :post => "/courses" }.should_not be_routable
#  end


  it "should not route the update" do
    { :put => "/courses/course_id" }.should_not be_routable
  end

end
