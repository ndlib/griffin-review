require 'spec_helper'

describe BannerCourse do

  it "treats the same course id with a different semester as a different course "

  it "has a title" do
    bn = BannerCourse.new("ASDF", "ASDF")
    bn.title.should == 'Course 1'
  end


  it "has an instructor" do
    bn = BannerCourse.new("ASDF", "ASDF")
    bn.instructor.should == 'instructor'
  end


  it "has students"


  it "has TAs"

  describe "reserve material" do
    it "has a list of reserve material"


  end
end


