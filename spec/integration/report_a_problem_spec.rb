require 'spec_helper'


describe 'Report a Problem Spec' do


  it "allows you to submit a report" do
    semester = Factory(:semester, code: '201300')
    u = FactoryGirl.create(:student, username: 'abuchman')
    login_as u

    VCR.use_cassette 'report_a_problem_form' do
      visit new_report_problem_path(:path => '/my/path')
    end


    fill_in "comments", with: "My problem Comments"

    click_on "Send Message"

    expect(last_email.to.include?('nd@service-now.com')).to be_true
  end


  def last_email
    ActionMailer::Base.deliveries.last
  end
end
