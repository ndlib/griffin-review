require 'spec_helper'

describe CopyCourseReservesForm do

  let(:user) { mock(User, :username => 'instructor') }

  before(:each) do
    stub_courses!

    semester = FactoryGirl.create(:semester)
    FactoryGirl.create(:next_semester)

    reserves = UserCourseListing.new(user, semester.code)

    @from_course = reserves.course('previous_ACCT_20100')
    @to_course = reserves.course('current_ACCT_20200')

    @copy_course = CopyCourseReservesForm.new(@from_course, @to_course)
  end


  it "displays the from course title" do
    @copy_course.from_course_title.should == @from_course.title
  end


  it "displays the to course title" do
    @copy_course.to_course_title.should == @to_course.title
  end


  it "generates a list of courses in the current semester to copy to " do
    CopyCourseReservesForm.current_semester_courses(user).size.should == 1
  end


  it "generates a list of coursers in the next semester to copy to " do
    CopyCourseReservesForm.next_semester_courses(user).size.should == 1
  end


  describe :copy do

    before(:each) do
      @reserve = Reserve.factory(FactoryGirl.create(:request, :available), @from_course)

    end

    it "is returns true when it is successful" do
      @copy_course = CopyCourseReservesForm.new(@from_course, @to_course, { reserve_ids: [ @reserve.id ] })

      reserves = @copy_course.copy_items()
      reserves.first.id.should_not == @reserve.id
      reserves.first.title.should == @reserve.title
    end


    it "skips reserve ids that are not real reserves" do
      @copy_course = CopyCourseReservesForm.new(@from_course, @to_course, { reserve_ids: [ 5234234, "a", Object.new ] })

      reserves = @copy_course.copy_items()
      reserves.should == []
    end

    it "skips if nothing is passed in" do
      @copy_course = CopyCourseReservesForm.new(@from_course, @to_course, { })

      reserves = @copy_course.copy_items()
      reserves.should == []
    end
  end
end
