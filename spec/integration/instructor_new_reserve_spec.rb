require 'spec_helper'

describe "Instructor New Reserve" do

  let(:username) { 'cmick'}
  let(:reserve_course) { '201300_4193' }
  let(:semester_code) { '201300'}
  let(:next_semester_code) { '201310'}
  let(:current_course_key) { "instructor/#{reserve_course}/#{username}" }


  before(:each) do
    semester = Factory(:semester, code: semester_code)
    next_semester = Factory(:next_semester, code: next_semester_code)

    u = FactoryGirl.create(:student, username: username)
    login_as u

    stub_ssi!
    turn_on_ldap!

    VCR.use_cassette current_course_key do
      @current_course = CourseSearch.new.get(reserve_course)
    end

  end


  it "an instructor can add a book request"

  it "allows an instructor to add a book chapter request"


  it "allows an instructor to add a video request" do
    VCR.use_cassette 'new-instructor-video-page' do
      visit new_course_reserve_path(@current_course.id)
    end

    within("#video_form") do
      fill_in("Title", with: 'title')
      fill_in("video_needed_by_id", with: 22.days.from_now)

      click_button "Save"
    end

    expect(page).to have_selector('.alert-success')

    click_link('I am Done')

    expect(page).to have_selector('.title', text: 'title')
  end


  it "does not allow more then 255 characters to be added to the fields" do
    VCR.use_cassette 'new-instructor-video-page' do
      visit new_course_reserve_path(@current_course.id)
    end

    long_string = ""
    300.times { long_string += "e" }

    within("#video_form") do
      fill_in("Title", with: long_string)
      fill_in("Director or Publisher", with: long_string)
      fill_in("video_needed_by_id", with: 22.days.from_now)

      click_button "Save"
    end

    expect(page).to have_selector('.alert-success')

    click_link('I am Done')

    expect(page).to have_selector('.title', text: long_string.truncate(250))

  end


  it "allows an instrucotr to add an article request"

end
