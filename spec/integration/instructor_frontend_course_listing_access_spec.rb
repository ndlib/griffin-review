require 'spec_helper'

describe "Instructor Frontend Course Listing Access" do


  before(:each) do
    @semester = FactoryGirl.create(:semester)
    @next_semester = FactoryGirl.create(:next_semester)

    u = FactoryGirl.create(:instructor)
    login_as u

    @current_course = mock(Course, id: 'id', title: 'current title', full_title: "full_title", crosslisted_course_ids: [], section_numbers: ['2'], semester: @semester, semester_name: 'semester_name')
    @next_course = mock(Course, id: 'id', title: 'next title', full_title: "full_title",crosslisted_course_ids: [], section_numbers: ['3'], semester: @next_semester, semester_name: 'semester_name')
    @enrolled_course = mock(Course, id: 'id', title: 'enrolled title', full_title: "full_title", instructor_name: 'name', crosslisted_course_ids: [], section_numbers: ['2'], semester: @semester, semester_name: 'semester_name')
  end


  describe :instructor_has_reserves_in_current_semester do
    before(:each) do
      UserCourseListing.any_instance.stub(:enrolled_courses).and_return([])
      UserCourseListing.any_instance.stub(:current_instructed_courses).and_return([@current_course])
      UserCourseListing.any_instance.stub(:upcoming_instructed_courses).and_return([])
    end


    it "shows the current course" do
      visit root_path

      within("table.instructed_courses") do
        page.should have_content(@current_course.title)
      end
    end

  end

  describe :instructor_has_reserves_in_next_semester do
    before(:each) do
      UserCourseListing.any_instance.stub(:enrolled_courses).and_return([])
      UserCourseListing.any_instance.stub(:current_instructed_courses).and_return([])
      UserCourseListing.any_instance.stub(:upcoming_instructed_courses).and_return([@next_course])
    end


    it "shows the next course" do
      visit root_path

      within("table.instructed_courses") do
        page.should have_content(@next_course.title)
      end
    end

  end


  describe :instructor_has_reserves_in_both_semesters do
    before(:each) do
      UserCourseListing.any_instance.stub(:enrolled_courses).and_return([])
      UserCourseListing.any_instance.stub(:current_instructed_courses).and_return([@current_course])
      UserCourseListing.any_instance.stub(:upcoming_instructed_courses).and_return([@next_course])
    end


    it "shows the next course" do
      visit root_path

      page.should have_content(@next_course.title)
      page.should have_content(@current_course.title)
    end


    it "shows not have an alert message for the upcoming semester" do
      visit root_path

      page.should_not have_selector('p.alert')
    end
  end


  describe :instructor_is_enrolled_in_courses_as_well_as_instructing_courses do
    before(:each) do
      UserCourseListing.any_instance.stub(:enrolled_courses).and_return([@enrolled_course])
      UserCourseListing.any_instance.stub(:current_instructed_courses).and_return([@current_course])
      UserCourseListing.any_instance.stub(:upcoming_instructed_courses).and_return([@next_course])
    end


    it "shows the next course" do
      visit root_path

      page.should have_content(@enrolled_course.title)
      page.should have_content(@next_course.title)
      page.should have_content(@current_course.title)
    end

  end

  describe :instructor_has_no_courses do
    before(:each) do
      UserCourseListing.any_instance.stub(:enrolled_courses).and_return([])
      UserCourseListing.any_instance.stub(:current_instructed_courses).and_return([])
      UserCourseListing.any_instance.stub(:upcoming_instructed_courses).and_return([])
    end


    it "shows not have an alert message for the upcoming semester" do
      visit root_path

      page.should have_selector('p.alert')
    end
  end

end
