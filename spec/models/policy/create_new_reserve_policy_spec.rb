require 'spec_helper'

describe CreateNewReservesPolicy do

  it "allows you to create a new reserve if the course is in the current semester" do
    course = double(Course, id: 'id', semester: FactoryBot.create(:semester))

    CreateNewReservesPolicy.new(course).can_create_new_reserves?.should be_truthy
  end


  it "allows you to create a new reserve if the course is in the next semeseter" do
    course = double(Course, id: 'id', semester: FactoryBot.create(:next_semester))

    CreateNewReservesPolicy.new(course).can_create_new_reserves?.should be_truthy
  end


  it "does not allow you to create a new reserve if the course is in the previous semester" do
    course = double(Course, id: 'id', semester: FactoryBot.create(:previous_semester))

    CreateNewReservesPolicy.new(course).can_create_new_reserves?.should be_falsey
  end



end
