require 'spec_helper'


describe "Instructor Copy Spec" do

  let(:username) { 'cmick'}

  let(:reserve_course) { '201300_4193' }
  let(:next_reserve_course) { '201310_12754' }

  let(:semester_code) { '201300'}
  let(:next_semester_code) { '201310'}

  let(:current_course_key) { "instructor/#{reserve_course}/#{username}" }
  let(:next_course_key) { "instructor/#{next_reserve_course}/#{username}" }
  let(:listing_course_key) { "instructor/listing/#{username}/#{semester_code}" }


  before(:each) do
    semester = Factory(:semester, code: semester_code)
    next_semester = Factory(:next_semester, code: next_semester_code)

    u = FactoryGirl.create(:student, username: username)
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


  describe :step1 do

    it "loads " do
      mock_reserve FactoryGirl.create(:request, :available, :book), @current_course

      VCR.use_cassette listing_course_key do
        visit course_copy_path(@next_course.id)
      end

      within("table.instructed_courses") do
        expect(page).to have_selector('a', text: @current_course.title)
      end
    end


    it "only allows you to copy from courses that have reserves" do
      VCR.use_cassette next_course_key do
        visit course_reserves_path(@next_course.id)
      end

      VCR.use_cassette listing_course_key do
        visit course_copy_path(@next_course.id)
      end

      expect(page).to have_selector('p.alert', text: "You do not have any courses that have reaserves to copy from.")

      mock_reserve FactoryGirl.create(:request, :available, :book), @current_course

      VCR.use_cassette listing_course_key do
        visit course_copy_path(@next_course.id)
      end

      within("table.instructed_courses") do
        click_link @current_course.title
      end
    end

  end


  describe :step2 do

    it "loads" do
      mock_reserve FactoryGirl.create(:request, :available, :book), @current_course

      VCR.use_cassette listing_course_key do
        visit course_copy_path(@next_course.id)
      end

      within("table.instructed_courses") do
        click_link @current_course.title
      end
    end


    it "allows you to select items to copy"
      # currently requires javascript
  end


  describe :copy do

  end




end
