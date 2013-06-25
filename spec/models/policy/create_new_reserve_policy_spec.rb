require 'spec_helper'

describe CreateNewReservesPolicy do

  let(:course_search) {CourseSearch.new}

  before(:each) do
    stub_courses!
  end

  it "allows you to create a new reserve if the course is in the current semester" do
    FactoryGirl.create(:semester)
    course = course_search.get('current_multisection_crosslisted')

    CreateNewReservesPolicy.new(course).can_create_new_reserves?.should be_true
  end


  it "allows you to create a new reserve if the course is in the next semeseter" do
    FactoryGirl.create(:next_semester)
    course = course_search.get('next_simple')

    CreateNewReservesPolicy.new(course).can_create_new_reserves?.should be_true
  end


  it "does not allow you to create a new reserve if the course is in the previous semester" do
    FactoryGirl.create(:previous_semester)
    course = course_search.get('previous_multisection')

    CreateNewReservesPolicy.new(course).can_create_new_reserves?.should be_false
  end



end
