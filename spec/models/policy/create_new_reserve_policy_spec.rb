require 'spec_helper'

describe CreateNewReservesPolicy do

  let(:course_api) {CourseApi.new}

  before(:each) do
    stub_courses!
  end

  it "allows you to create a new reserve if the course is in the current semester" do
    FactoryGirl.create(:semester)
    course = course_api.get('current_ACCT_20200')

    CreateNewReservesPolicy.new(course).can_create_new_reserves?.should be_true
  end


  it "allows you to create a new reserve if the course is in the next semeseter" do
    FactoryGirl.create(:next_semester)
    course = course_api.get('next_BLA_234234')

    CreateNewReservesPolicy.new(course).can_create_new_reserves?.should be_true
  end


  it "does not allow you to create a new reserve if the course is in the previous semester" do
    FactoryGirl.create(:previous_semester)
    course = course_api.get('previous_ACMS_60882')

    CreateNewReservesPolicy.new(course).can_create_new_reserves?.should be_false
  end



end
