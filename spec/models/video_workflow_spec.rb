require 'spec_helper'

describe VideoWorkflow do

  before(:all) do
    @faculty_user_a = Factory.create(:user)
    @faculty_user_b = Factory.create(:user)
    @faculty_role = Factory.create(:faculty_role)
    @faculty_user_a.roles = [@faculty_role]
    @faculty_user_b.roles = [@faculty_role]
    @current_semester = Factory.create(:semester)
    @request_a = Factory.create(:generic_request, :semester_id => @current_semester.id, :user_id => @faculty_user_a.id)
    @request_b = Factory.create(:generic_request, :needed_by => Date.today + 4.weeks, :semester_id => @current_semester.id, :user_id => @faculty_user_b.id)
    @request_c = Factory.create(:generic_request, :needed_by => Date.today + 14.days, :semester_id => @current_semester.id, :user_id => @faculty_user_b.id)
    @media_admin_role = Factory.create(:media_admin_role)
    @media_admin_user = Factory.create(:user)
    @media_admin_user.roles = [@media_admin_role]
    @jane_user = Factory.create(:user)
  end

  it "has a valid factory" do
    Factory.create(:generic_request, :semester_id => @current_semester.id, :user_id => @faculty_user_b.id).should be_valid
  end
  it "is invalid without properly formatted course id" do
    @request_a.course = "Business 101"
    @request_a.should be_invalid
  end
  it "is invalid without a course id" do
    @request_a.course = ''
    @request_a.should be_invalid
  end
  it "is invalid without a title" do
    @request_a.title = ''
    @request_a.should be_invalid
  end
  it "is invalid with out a needed by date" do
    @request_a.needed_by = ''
    @request_a.should be_invalid
  end

  describe "Modifying a workflow request" do
    it "updates a request to reflect library ownership" do
      @request_b.library_owned = true
      @request_b.save
      @request_check = Request.find(@request_b.id)
      @request_check.should be_library_owned
    end
    it "updates a request to reflect processed status" do
      @request_b.request_processed = true
      @request_b.save
      @request_check = Request.find(@request_b.id)
      @request_check.should be_request_processed
    end
  end

end
