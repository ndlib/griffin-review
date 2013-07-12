require 'spec_helper'

describe "Student Frontend Access" do

  before(:each) do
    FactoryGirl.create(:semester)
    FactoryGirl.create(:next_semester)

    stub_ssi!
    stub_courses!
    stub_discovery!

    u = FactoryGirl.create(:student)
    login_as u
  end


  describe :student_has_reserves do

    before(:each) do
      @test_course = CourseSearch.new.get('current_multisection_crosslisted')

      UserCourseListing.any_instance.stub(:enrolled_courses).and_return([@test_course])
      CourseReserveList.any_instance.stub(:get_course).and_return(@test_course)
    end


    it "allows the student to click to view their class" do
      visit root_path

      within("table") do
        click_link(@test_course.title)
      end
    end


    it "allows the student to download a class resource" do
      @file_reserve = mock_reserve FactoryGirl.create(:request, :available, :book_chapter), @test_course
      Course.any_instance.stub(:published_reserves).and_return([@file_reserve])

      visit course_reserves_path(@test_course.id)
      click_link(@file_reserve.title)
    end


    it "allows the student to retreive a link resource" do
      @url_reserve  = mock_reserve FactoryGirl.create(:request, :available, :video), @test_course

      visit course_reserves_path(@test_course.id)

      click_link(@url_reserve.title)
    end

  end

  describe :student_does_not_have_reserves do

    it "shows a warning if the student has no currrent reserves" do
      visit root_path

      page.should have_selector('p.alert')
    end
  end


end
