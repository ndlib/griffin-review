require 'spec_helper'

describe CopyCourseListings do

  before(:each) do
    reserves = Reserves.new("USER", "SEMESTER")
    @from_course = reserves.course(1)
    @to_course = reserves.course(1)

    @copy_course = CopyCourseListings.new(@from_course, @to_course)
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
