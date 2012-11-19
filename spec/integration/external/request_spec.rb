require 'spec_helper'

describe "Digitization Request Integration" do

  before(:all) do
    @faculty_role = Factory.create(:faculty_role)
    @faculty_user = Factory.create(:user)
    @faculty_user.roles = [@faculty_role]
    @semester_a = Factory.create(:semester)
    @semester_b = Factory.create(:semester)
    @semester_c = Factory.create(:semester)
    @request_a = Factory.build(:generic_request)
  end

  describe "Visits new video processing request form" do
    before :all do
      Capybara.default_wait_time =5 
      Capybara.current_driver = :selenium
    end
    it "fills in request form and submits with valid data" do
      login_as @faculty_user
      visit new_video_request_path
      click_button 'Close'
      fill_in 'Video Title', :with => @request_a.title
      fill_in 'Course', :with => @request_a.course
      check 'Library Owns?'
      choose 'request_extent_all'
      choose 'request_extent_all'
      select @semester_b.full_name, :from => 'Semester'
      fill_in 'Date Needed By', :with => Date.today + 3.weeks
      fill_in 'Special Instructions', :with => 'Lorem Ipsum'
      click_button 'Finalize Request'
      page.should have_content('Status of Course Video Request') 
      logout @faculty_user
    end
    it "returns error message with invalid data" do
      login_as @faculty_user
      visit new_video_request_path
      fill_in 'Video Title', :with => @request_a.title
      fill_in 'Course', :with => 'Business 101'
      fill_in 'Special Instructions', :with => @request_a.note
      click_button 'Finalize Request'
      page.should have_content('Please review the problems below:')
      logout @faculty_user
    end
  end

  describe "Visits a status page for existing request" do
    it "displays the current status of the request" do
      login_as @faculty_user
      visit new_video_request_path
      fill_in 'Video Title', :with => @request_a.title
      fill_in 'Course', :with => @request_a.course
      check 'Library Owns?'
      select @semester_b.full_name, :from => 'Semester'
      fill_in 'Date Needed By', :with => Date.today + 3.weeks
      fill_in 'Special Instructions', :with => 'Lorem Ipsum'
      click_button 'Finalize Request'
      @last_request = Request.last
      visit video_request_status_path(@last_request)
      page.should have_content(@last_request.title)
      page.should have_content(@last_request.course)
      logout @faculty_user
    end
  end
end

