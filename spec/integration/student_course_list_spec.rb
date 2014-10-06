require 'spec_helper'

describe 'Student Course Access ' do

  let(:username) { 'bcarrico'}

  let(:reserve_course) { '201300_1644' }

  let(:semester_code) { '201300'}
  let(:next_semester_code) { '201310'}

  let(:current_course_key) { "student/#{reserve_course}/#{username}" }
  let(:listing_course_key) { 'student/listing/#{username}' }


  let(:ldap) { Net::LDAP::Entry.new }
  let(:instructor) { FactoryGirl.create(:instructor, username: 'jhartzle' )}

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

    Course.any_instance.stub(:primary_instructor).and_return(instructor)

  end


  it "homepage -> show page" do
    res = mock_reserve FactoryGirl.create(:request, :available, :book_chapter), @current_course
    ldap['uid'] = 'cwray'
    ldap['mail'] = 'cwray@nd.edu'
    ldap['displayname'] = 'Christopher Wray'
    ldap['givenname'] = 'Christopher'
    ldap['sn'] = 'Wray'

    VCR.use_cassette listing_course_key do
      expect(User).to receive(:ldap_lookup).with('cwray').and_return(ldap).at_least(:once)
      visit root_path
    end

    VCR.use_cassette current_course_key do
      within("table.enrolled_courses") do
        click_link @current_course.title
      end
    end
  end


  it "does not show courses that have no reserves"  do
    VCR.use_cassette listing_course_key do
      visit root_path
    end

    expect(page).to_not have_selector('table.enrolled_courses', text: @current_course.title)
  end
end
