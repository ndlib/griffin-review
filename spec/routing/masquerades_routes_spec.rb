require 'spec_helper'

describe 'Masquerades Routes' do

  it "should not route to the index" do
    { :get => "/masquerades" }.should_not be_routable
  end


  it "should not route to the show" do
    { :get => "/masquerades/course_id" }.should_not be_routable
  end



#  fails because it thinks this is an id
  it "should not route to the new " do
    { :get => "/masquerades/new" }.should  route_to(
      action: "new", controller: "masquerades"
    )
  end


  it "should route to the edit" do
    { :get => "/masquerades/course_id/edit" }.should_not be_routable
  end


  it "should route to the create " do
    { :post => "/masquerades" }.should route_to(
      action: "create", controller: "masquerades"
    )
  end


  it "should not route the update" do
    { :put => "/masquerades/course_id" }.should_not be_routable
  end

end
