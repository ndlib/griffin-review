require 'spec_helper'

describe CreateNewReservesPolicy do

  it "allows you to create a new reserve if the course is in the current semester" do
    course = double(Course, id: 'id', semester: FactoryGirl.create(:semester))

    CreateNewReservesPolicy.new(course).can_create_new_reserves?.should be_true
  end


  it "allows you to create a new reserve if the course is in the next semeseter" do
    course = double(Course, id: 'id', semester: FactoryGirl.create(:next_semester))

    CreateNewReservesPolicy.new(course).can_create_new_reserves?.should be_true
  end


  it "does not allow you to create a new reserve if the course is in the previous semester" do
    course = double(Course, id: 'id', semester: FactoryGirl.create(:previous_semester))

    CreateNewReservesPolicy.new(course).can_create_new_reserves?.should be_false
  end



end
