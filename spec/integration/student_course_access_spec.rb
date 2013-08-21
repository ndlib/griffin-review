require 'spec_helper'


describe 'Student Course Access ' do

  let(:username) { 'abuchman'}
  let(:current_course_key) { "student/#{current_course}/#{username}"}
  let(:semester_code) { '201300'}
  let(:next_semester_code) { '201310'}
  let(:current_course) { '201300_3605' }


  before(:each) do
    semester = Factory(:semester, code: semester_code)
    next_semester = Factory(:next_semester, code: next_semester_code)

    u = FactoryGirl.create(:student, username: username)
    login_as u

    stub_ssi!
    turn_on_ldap!

    VCR.use_cassette current_course_key do
      @current_course = CourseSearch.new.get(current_course)
    end
  end


  it "Shows an avaiable book reserve" do
    res = mock_reserve FactoryGirl.create(:request, :available, :book), @current_course

    VCR.use_cassette current_course_key do
      visit course_reserves_path(@current_course.id)
    end

    # text exists
    expect(page).to have_selector('div.record-book h2.title', text: res.title)
    # is not a link
    expect(page).to_not have_selector('div.record-book h2.title a')
  end


  it "shows an available book chapter" do
    res = mock_reserve FactoryGirl.create(:request, :available, :book_chapter), @current_course

    VCR.use_cassette current_course_key do
      visit course_reserves_path(@current_course.id)
    end

    click_link(res.title)

    expect_copyright_form!(page)

    click_button('I Accept')

    expect(page.response_headers["Content-Disposition"]).to eq "attachment; filename=\"test.pdf\""
  end


  it "shows a journal with a url redirect" do
    res = mock_reserve FactoryGirl.create(:request, :available, :journal_url), @current_course

    VCR.use_cassette current_course_key do
      visit course_reserves_path(@current_course.id)
    end

    # it does something weird with the external redirect so it needs to be tested this way
    ApplicationController.any_instance.should_receive(:redirect_to).with(res.url)
    click_link(res.title)
  end


  it "shows a journal with a file attached to it" do
    res = mock_reserve FactoryGirl.create(:request, :available, :journal_file), @current_course

    VCR.use_cassette current_course_key do
      visit course_reserves_path(@current_course.id)
    end

    click_link(res.title)

    expect_copyright_form!(page)

    click_button('I Accept')

    expect(page.response_headers["Content-Disposition"]).to eq "attachment; filename=\"test.pdf\""
  end


  it "shows a video from our streaming server" do
    res = mock_reserve FactoryGirl.create(:request, :available, :video), @current_course

    VCR.use_cassette current_course_key do
      visit course_reserves_path(@current_course.id)
    end

    click_link(res.title)

    expect_copyright_form!(page)

    click_button('I Accept')

    expect(page.response_headers["Content-Disposition"]).to eq "inline; filename=\"movie.mov\""
  end


  it "shows a video from another url " do
    res = mock_reserve FactoryGirl.create(:request, :available, :video_external), @current_course

    VCR.use_cassette current_course_key do
      visit course_reserves_path(@current_course.id)
    end

    click_link(res.title)

    expect_copyright_form!(page)

    # it does something weird with the external redirect so it needs to be tested this way
    ApplicationController.any_instance.should_receive(:redirect_to).with(res.url)
    click_button('I Accept')
  end


  it "does not show a request that is in the new phase" do
    res = mock_reserve FactoryGirl.create(:request, :new, :book_chapter), @current_course

    VCR.use_cassette current_course_key do
      visit course_reserves_path(@current_course.id)
    end

    expect(page).to_not have_selector('div.record-book h2.title', text: res.title)
  end


  it "does not show a request that is inprocess " do
    res = mock_reserve FactoryGirl.create(:request, :inprocess, :book_chapter), @current_course

    VCR.use_cassette current_course_key do
      visit course_reserves_path(@current_course.id)
    end

    expect(page).to_not have_selector('div.record-book h2.title', text: res.title)
  end


  it " does not show a request that is removed" do
    res = mock_reserve FactoryGirl.create(:request, :removed, :book_chapter), @current_course

    VCR.use_cassette current_course_key do
      visit course_reserves_path(@current_course.id)
    end

    expect(page).to_not have_selector('div.record-book h2.title', text: res.title)
  end


  it "allows a copyright to be canceled" do
    res = mock_reserve FactoryGirl.create(:request, :available, :book_chapter), @current_course

    VCR.use_cassette current_course_key do
      visit course_reserve_path(@current_course.id, res.id)
    end

    click_link('I do not accept')

    expect(current_path).to eq course_reserve_path(@current_course.id, res.id)
  end


  def expect_copyright_form!(page)
    expect(page).to have_selector('h1', text: 'WARNING CONCERNING COPYRIGHT RESTRICTIONS')
  end
end
