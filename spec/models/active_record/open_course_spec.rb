require 'spec_helper'


describe OpenCourse do

  after(:each) do
    OpenItem.destroy_all
    OpenCourse.destroy_all
    OpenItemCourseLink.destroy_all
  end


  it "has reserves associated with it" do
    oic = FactoryGirl.create(:open_item_course_link)

    oic.open_course.reserves.size.should == 1
  end
end
