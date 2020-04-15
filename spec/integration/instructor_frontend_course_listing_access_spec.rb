require 'spec_helper'

describe "Instructor Frontend Course Listing Access" do

  let(:username) { 'cmick'}

  let(:reserve_course) { '201300_4193' }
  let(:next_reserve_course) { '201310_12754' }

  let(:semester_code) { '201300'}
  let(:next_semester_code) { '201310'}

  let(:current_course_key) { "instructor/#{reserve_course}/#{username}" }
  let(:next_course_key) { "instructor/#{next_reserve_course}/#{username}" }
  let(:listing_course_key) { 'instructor/listing/#{username}' }


  before(:each) do
    semester = Factory(:semester, code: semester_code)
    next_semester = Factory(:next_semester, code: next_semester_code)

    u = FactoryBot.create(:student, username: username)
    login_as u

    stub_ssi!
    turn_on_ldap!
    User.stub(:ldap_lookup).and_return( { givenname: ['Bob'], sn: ['SN'], ndvanityname: ['ndvanityname'], mail: ['mail@nd.edu'], displayname: ['displayname'] } )


    VCR.use_cassette current_course_key do
      @current_course = CourseSearch.new.get(reserve_course)
    end
    VCR.use_cassette next_course_key do
      @next_course = CourseSearch.new.get(next_reserve_course)
    end

  end


  describe :instructor_has_reserves_in_current_semester do

    it "shows the current course" do
      VCR.use_cassette listing_course_key do
        visit root_path
      end

      within("table.instructed_courses tr#course_row_#{@current_course.id}") do
        click_link @current_course.title
      end
    end

  end

  describe :instructor_has_reserves_in_next_semester do

    it "shows the next course" do
      VCR.use_cassette listing_course_key do
        visit root_path
      end


      within("table.instructed_courses tr#course_row_#{@next_course.id}") do
        click_link(@next_course.title)
      end
    end

  end


  describe :instructor_has_no_courses do
    before(:each) do
      ListUsersCourses.any_instance.stub(:enrolled_courses).and_return([])
      ListUsersCourses.any_instance.stub(:current_instructed_courses).and_return([])
      ListUsersCourses.any_instance.stub(:upcoming_instructed_courses).and_return([])
    end


    it "shows not have an alert message for the upcoming semester" do
      visit root_path

      page.should have_text('You do not currently have any courses with reserves.')
    end
  end

end
