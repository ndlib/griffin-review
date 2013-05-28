require 'spec_helper'

describe CopyReserves do

  let(:student_user) { mock(User, :username => 'student') }

  let(:semester) { FactoryGirl.create(:semester)}

  before(:each) do
    stub_courses!
    reserves = UserCourseListing.new(student_user, semester.code)

    @from_course = reserves.course('current_normalclass_100')
    @to_course = reserves.course('current_supersection_100')

    @copy_course = CopyReserves.new(@from_course, @to_course)
  end


  it "displays the from course title" do
    @copy_course.from_course_title.should == @from_course.title
  end


  it "displays the to course title" do
    @copy_course.to_course_title.should == @to_course.title
  end


  describe :copy do

    it "is returns true when it is successful" do
      @copy_course.copy_items([3]).should be_true
    end

  end
end
