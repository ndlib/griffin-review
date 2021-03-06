require "spec_helper"
=begin
describe RequestMailer do

  before(:all) do
    @faculty_user_a = FactoryBot.create(:user)
    @faculty_user_b = FactoryBot.create(:user)
    @faculty_role = FactoryBot.create(:faculty_role)
    @faculty_user_a.roles = [@faculty_role]
    @faculty_user_b.roles = [@faculty_role]
    @current_semester = FactoryBot.create(:semester, :code => 'code1')
    @next_semester = FactoryBot.create(:semester, :code => 'code2', :date_begin => Date.today + 3.months, :date_end => Date.today + 6.months)
    @distant_semester = FactoryBot.create(:semester, :code => 'code3', :date_begin => Date.today + 7.months, :date_end => Date.today + 12.months)
    @old_semester = FactoryBot.create(:semester, :code => 'code4', :date_begin => Date.today - 6.months, :date_end => Date.today - 2.months)
    @request_a = FactoryBot.create(:generic_request, :semester_id => @current_semester.id)
    @request_b = FactoryBot.create(:generic_request, :needed_by => Date.today + 4.weeks, :semester_id => @current_semester.id)
    @request_c = FactoryBot.create(:generic_request, :needed_by => Date.today + 14.days, :semester_id => @current_semester.id)
    @media_admin_role = FactoryBot.create(:media_admin_role)
    @media_admin_user = FactoryBot.create(:user)
    @media_admin_user.roles = [@media_admin_role]
    ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
  end

  before(:each) do
    ActionMailer::Base.deliveries = []
  end

  describe "Media admins notification" do
    it "can send media admins a notification" do
      ActionMailer::Base.deliveries.should be_empty
      mail = RequestMailer.media_admin_request_notify(@request_b)
      mail.body.should =~ /#{@request_b.user.display_name}/
      mail.body.should =~ /#{@request_b.title}/
      mail.to.first.should eq @media_admin_user.email
    end
  end

  describe "Requester notification" do
    it "can send requester a notification" do
      ActionMailer::Base.deliveries.should be_empty
      mail = RequestMailer.requester_notify(@request_b)
      mail.body.should =~ /#{@request_b.user.display_name}/
      mail.body.should =~ /#{@request_b.title}/
      mail.from.first.should eq 'reserves-system@nd.edu'
      mail.to.first.should eq @request_b.user.email
    end

  end

=end
