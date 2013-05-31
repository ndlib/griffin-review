require 'spec_helper'

describe "Student Frontend Access" do

  before(:each) do
    FactoryGirl.create(:semester)

    stub_courses!
    stub_discovery!

    u = FactoryGirl.create(:student)
    login_as u

    @test_course = CourseApi.new.get(u.username, "current_normalclass_100")

    @file_reserve = Reserve.factory(FactoryGirl.create(:request, :available, :book_chapter, :course_id => @test_course.reserve_id), @test_course)
    @url_reserve  = Reserve.factory(FactoryGirl.create(:request, :available, :video, :course_id => @test_course.reserve_id), @test_course)
  end


  it "allows the student to click to view their class" do
    visit root_path

    within("table") do
      click_link(@test_course.title)
    end
  end


  it "allows the student to download a class resource" do
    visit course_path(@test_course.id)
    binding.pry
    click_link(@file_reserve.title)
  end


  it "allows the student to retreive a link resource" do
    visit course_path(@test_course.id)

    ActionController::Base.any_instance.should_receive(:redirect_to)
    click_link(@url_reserve.title)
  end


end
