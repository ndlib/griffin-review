require "spec_helper"

describe SemesterMailer do

  before(:each) do
    ActionMailer::Base.deliveries = []
  end

  describe "::semester_notify" do
    
    it "sends admins semester alert notification" do
      ActionMailer::Base.deliveries.should be_empty
      mail = SemesterMailer.semester_notify
      expect(mail.body).to match /#{Date.today}/
      expect(mail.to).to include 'jhartzle@nd.edu'
      expect(mail.from.first).to eq 'reserves-system@nd.edu'
    end

  end

end
