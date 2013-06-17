require 'spec_helper'

describe UserArchiveCourseListing do

  let(:instructor_user) { mock(User, :username => 'instructor') }
  let(:semester) { FactoryGirl.create(:semester)}
  let(:previous_semester) { FactoryGirl.create(:previous_semester)}

  before(:each) do
    semester
    stub_courses!
  end


  describe :previous_semesters do

    it "returns all the semesters that are in the past."
  end


  describe :semester_instructed_courses_with_reserves do

    it "returns only courses that have reserves"

    it " returns only courses for the semester passed in"
  end

end
