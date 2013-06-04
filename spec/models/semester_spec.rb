require 'spec_helper'

describe Semester do

  before(:all) do
    @current_semester = Factory.create(:semester, :code => 'code', :date_end => Date.today + 3.months)
    @next_semester = Factory.create(:semester, :code => 'code1', :date_begin => Date.today + 3.months, :date_end => Date.today + 6.months)
    @distant_semester = Factory.create(:semester, :code => 'code2', :date_begin => Date.today + 7.months, :date_end => Date.today + 12.months)
    @last_semester = Factory.create(:semester, :code => 'code3', :date_begin => Date.today - 6.months, :date_end => Date.today - 2.months)
  end

  it do
    @current_semester.should be_valid
  end

  it "should have both a code and a full name" do
    @current_semester.full_name.should_not be_nil
    @current_semester.code.should_not be_nil
  end
  it "should report an error if code or full name are blank" do
    @bad_semester = Factory.build(:semester, :code=> '', :full_name => '')
    @bad_semester.code = ''
    @bad_semester.should have_at_least(1).error_on(:full_name)
    @bad_semester.should have_at_least(1).error_on(:code)
  end

  context "which is proximate" do
    it "should be the current or one of next two future semesters" do
      @current_semester.should be_proximate
      @distant_semester.should_not be_proximate
    end

    it "can be found in an array of proximate semesters" do
#      [@current_semester, @next_semester, @last_semester, @distant_semester].each { |s| s.save }
#      Semester.proximates.should include(@last_semester, @current_semester, @next_semester)
#      Semester.proximates.should_not include(@distant_semester)
    end
  end


  it "gets the next semester" do
    @current_semester.next.should == @next_semester
  end
end
