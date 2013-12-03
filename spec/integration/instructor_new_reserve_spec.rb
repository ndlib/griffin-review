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


  it "an instructor can add a book request" do
    VCR.use_cassette 'new-instructor-video-page' do
      visit new_course_reserve_path(@current_course.id)
    end

    within("#book_form") do
      fill_in("Title", with: 'title')
      fill_in('Citation', with: "citation")
      fill_in("book_needed_by_id", with: 22.days.from_now)

      click_button "Save"
    end

    expect(page).to have_selector('.alert-success')

    click_link('I am Done')

    expect(page).to have_selector('.title', text: 'title')

    reserve = Reserve.factory(Request.last)
    expect(reserve.physical_reserve?).to be_true
    expect(reserve.electronic_reserve?).to be_false
  end


  it "allows an instructor to add a book chapter request" do
    VCR.use_cassette 'new-instructor-video-page' do
      visit new_course_reserve_path(@current_course.id)
    end

    within("#book_chapter_form") do
      fill_in("Title", with: 'title')
      fill_in('Citation', with: "citation")
      fill_in("book_chapter_needed_by_id", with: 22.days.from_now)
      fill_in("Chapter / Pages", with: "chapter 2")

      click_button "Save"
    end

    expect(page).to have_selector('.alert-success')

    click_link('I am Done')

    expect(page).to have_selector('.title', text: 'title')

    reserve = Reserve.factory(Request.last)
    expect(reserve.physical_reserve?).to be_false
    expect(reserve.electronic_reserve?).to be_true
  end


  it "allows an instructor to add a article request " do
    VCR.use_cassette 'new-instructor-video-page' do
      visit new_course_reserve_path(@current_course.id)
    end

    within("#article_form") do
      fill_in("Title", with: 'title')
      fill_in('Citation', with: "citation")
      fill_in("article_needed_by_id", with: 22.days.from_now)

      click_button "Save"
    end

    expect(page).to have_selector('.alert-success')

    click_link('I am Done')

    expect(page).to have_selector('.title', text: 'title')

    reserve = Reserve.factory(Request.last)
    expect(reserve.physical_reserve?).to be_false
    expect(reserve.electronic_reserve?).to be_true
  end


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

    reserve = Reserve.factory(Request.last)
    expect(reserve.physical_reserve?).to be_true
    expect(reserve.electronic_reserve?).to be_true
  end


  it "allows the video to be not electronic" do
    VCR.use_cassette 'new-instructor-video-page' do
      visit new_course_reserve_path(@current_course.id)
    end

    within("#video_form") do
      fill_in("Title", with: 'title')
      fill_in("video_needed_by_id", with: 22.days.from_now)
      check "instructor_reserve_request_electronic_reserve"

      click_button "Save"
    end

    reserve = Reserve.factory(Request.last)
    expect(reserve.physical_reserve?).to be_true
    expect(reserve.electronic_reserve?).to be_false
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

end
