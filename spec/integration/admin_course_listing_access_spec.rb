require 'spec_helper'

describe "Course Search" do

  before(:each) do
    @semester = FactoryGirl.create(:semester)
    @next_semester = FactoryGirl.create(:next_semester)

    stub_ssi!
    stub_courses!
    stub_discovery!

    u = FactoryGirl.create(:admin_user)
    login_as u
  end

  describe :admin_course_search do


    it "shows the search page to admins" do
      visit courses_path
      page.has_content?("Find Courses")
    end


    it "searches by semester " do
      course = mock(Course, id: 'id', title: "title", instructor_name: "bob", instructor_netid: 'netid', crosslisted_course_ids: [], section_numbers: ['1'], semester: @next_semester)
      CourseSearch.any_instance.stub(:search).and_return([course])

      visit courses_path

      fill_in("q", with: "search")
      select(@next_semester.full_name, from: 'semester_id')

      click_on("Go")
    end


    it "has a message if there are no results" do
      visit courses_path

      fill_in("q", with: "search")
      select(@next_semester.full_name, from: 'semester_id')

      click_on("Go")

      page.has_selector?('div.alert')
    end

  end

end
