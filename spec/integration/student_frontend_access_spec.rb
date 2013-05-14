require 'spec_helper'

describe "Student Frontend Access" do

  before(:each) do
    FactoryGirl.create(:semester)

    stub_courses!
    stub_discovery!

    u = FactoryGirl.create(:student)
    login_as u

    @user_course_listing = UserCourseListing.new(u)
    @test_course = @user_course_listing.courses_with_reserves.first
    @file_reserve = @test_course.reserve(3)
    @url_reserve = @test_course.reserve(4)
  end


  it "allows the student to click to view their class" do
    visit root_path

    within("table") do
      click_link(@test_course.title)
    end
  end


  it "allows the student to download a class resource" do
    visit course_path(@test_course.id)

    click_link(@file_reserve.title)
  end


  it "allows the student to retreive a link resource" do
    visit course_path(@test_course.id)

    ActionController::Base.any_instance.should_receive(:redirect_to)
    click_link(@url_reserve.title)
  end


end
