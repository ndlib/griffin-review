require 'spec_helper'

describe Semester do
  before(:each) do
    @current_semester = Factory.build(:semester)
    @next_semester = Factory.build(:semester, :date_begin => Date.today + 3.months, :date_end => Date.today + 6.months)
    @old_semester = Factory.build(:semester, :date_begin => Date.today - 6.months, :date_end => Date.today - 2.weeks)
  end

  it do
    @current_semester.should be_valid
  end
  
  it "should have both a code and a full name" do
    @current_semester.full_name.should_not be_nil
    @current_semester.code.should_not be_nil
  end
  it "should report an error if code or full name are blank" do
    @current_semester.full_name = ''
    @current_semester.code = ''
    @current_semester.should have_at_least(1).error_on(:full_name)
    @current_semester.should have_at_least(1).error_on(:code)
  end
  
  context "which is proximate" do
    it "should be the current or one of next two future semesters" do
      @current_semester.should be_proximate
      @old_semester.should_not be_proximate
    end
    it "can be found as an array of proximate semesters" do
      @current_semester.save
      @next_semester.save
      Semester.should_receive(:where) # .and_return([@current_semester, @next_semester])
      Semester.should have(2).proximates # include(@current_semester, @next_semester)
    end
  end
end
