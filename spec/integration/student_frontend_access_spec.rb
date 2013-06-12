require 'spec_helper'

describe "Student Frontend Access" do

  before(:each) do
    FactoryGirl.create(:semester)

    stub_courses!
    stub_discovery!

    u = FactoryGirl.create(:student)
    login_as u

    @test_course = CourseSearch.new.get('current_multisection_crosslisted')

    UserCourseListing.any_instance.stub(:courses_with_reserves).and_return([@test_course])
    UserCourseShow.any_instance.stub(:get_course).and_return(@test_course)

  end


  it "allows the student to click to view their class" do
    visit root_path

    within("table") do
      click_link(@test_course.title)
    end
  end


  it "allows the student to download a class resource" do
    @file_reserve = mock_reserve FactoryGirl.create(:request, :available, :book_chapter, :course_id => @test_course.reserve_id), @test_course
    Course.any_instance.stub(:published_reserves).and_return([@file_reserve])

    visit course_path(@test_course.id)
    click_link(@file_reserve.title)
  end


  it "allows the student to retreive a link resource" do
    @url_reserve  = mock_reserve FactoryGirl.create(:request, :available, :video, :course_id => @test_course.reserve_id), @test_course

    visit course_path(@test_course.id)

    ActionController::Base.any_instance.should_receive(:redirect_to)
    click_link(@url_reserve.title)
  end


end
