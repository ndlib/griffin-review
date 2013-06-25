require 'spec_helper'

describe 'Copy Reserves' do

  it "should route to the copy " do
    { :post => "/courses/course_id/copy/from_course_id/copy" }.should route_to(
      action: "copy", controller: "copy_reserves", course_id: "course_id", from_course_id: "from_course_id"
    )
  end


  it "should not route to the show" do
    { :get => "/courses/course_id/copy/from_course_id" }.should_not route_to(
      action: "step2", controller: "copy_reserves", course_id: "course_id", from_course_id: "from_course_id"
    )
  end


  it "should not route to the show" do
    { :get => "/courses/course_id/copy" }.should_not route_to(
      action: "step1", controller: "copy_reserves", course_id: "course_id"
    )
  end


end
