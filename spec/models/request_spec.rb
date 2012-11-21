require 'spec_helper'

describe Request do
  before(:each) do
    @semester_a = Factory.create(:semester)
    @faculty_user = Factory.create(:user)
    @faculty_role = Factory.create(:faculty_role)
    @faculty_user.roles = [@faculty_role]
    @request = Factory.create(:generic_request, :semester => @semester_a, :user => @faculty_user)
  end

  it "should be a valid request" do
    @request.should be_valid
  end

  it "should have a proper course code" do
    @request.course = 'IMPROPER PATTERN'
    @request.should have(1).error_on(:course)
  end

  it "should have a correct needed by date" do
   @request.needed_by = nil
   @request.should have(2).errors_on(:needed_by)
  end

  it "should not allow invalid title" do
    @request.title = nil
    @request.should have(1).error_on(:title)
  end
end
