require 'spec_helper'

describe Request do

  it "basic valid request passes validation" do
    valid_params = {:course_id => 'course id', :requestor_netid => 'requestornetid', :item => Item.new}
    Request.new(valid_params).should be_valid
  end


  it "requires an item" do
    Request.new.should have(1).error_on(:item)
  end


  it "requres a course id" do
    Request.new.should have(1).error_on(:course_id)
  end


  it "requires the requestor_netid" do
    Request.new.should have(1).error_on(:requestor_netid)
  end
end
