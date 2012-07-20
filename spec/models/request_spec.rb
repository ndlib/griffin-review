require 'spec_helper'

describe Request do
  before(:each) do
    @request = Request.new
    @request.title = 'TEST'
    @request.course = 'FA12 BUS 3023 01'
    @request.needed_by = 1.month.from_now
  end

  it do
    @request.should be_valid
  end

  it "should have a proper course code" do
    @request.course = 'IMPROPER PATTERN'
    @request.should have(1).error_on(:course)
  end

  it "should have a correct needed by date" do
   @request.needed_by = nil
   @request.should have(1).error_on(:needed_by)
  end

  it "should not allow invalid title" do
    @request.title = nil
    @request.should have(1).error_on(:title)
  end
end
