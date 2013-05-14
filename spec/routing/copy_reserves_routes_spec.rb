require 'spec_helper'

describe 'Copy Reserves' do

  it "should  route to the create " do
    { :post => "/courses/course_id/copy" }.should route_to(
      action: "create", controller: "copy_reserves", course_id: "course_id"
    )
  end


  it "should not route to the show" do
    { :get => "/courses/course_id/copy/id" }.should_not be_routable
  end


  it "should route to the index" do
    { :get => "/courses/course_id/copy" }.should_not be_routable
  end


  it "should not route to the destroy" do
    { :delete => "/courses/course_id/copy/id" }.should_not be_routable
  end



  it "should not route to the new " do
    { :get => "/courses/course_id/copy/new" }.should_not be_routable
  end


  it "should route to the edit" do
    { :get => "/courses/course_id/copy/id/edit" }.should_not be_routable
  end


  it "should not route the update" do
    { :put => "/courses/course_id/copy/id" }.should_not be_routable
  end

end
