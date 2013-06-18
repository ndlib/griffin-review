require 'spec_helper'

describe CopyCourseReservesForm do

  let(:user) { mock(User, :username => 'instructor') }
  let(:course_search) { CourseSearch.new }

  before(:each) do
    stub_courses!

    semester = FactoryGirl.create(:semester)
    next_semester = FactoryGirl.create(:next_semester)

    @from_course = mock(Course, :id => 'from_course_id', :title => 'from title', :instructor_name => 'name', :crosslist_id => 'from_reserve_id')
    @from_course.stub!(:semester).and_return(semester)
    @to_course = mock(Course, :id => 'to_course_id', :title => 'to title', :instructor_name => 'name', :crosslist_id => 'to_reserve_id')
    @to_course.stub!(:semester).and_return(next_semester)

    CopyCourseReservesForm.any_instance.stub(:get_course).with(@from_course.id).and_return(@from_course)
    CopyCourseReservesForm.any_instance.stub(:get_course).with(@to_course.id).and_return(@to_course)

    valid_params = { course_id: @from_course.id, to_course_id: @to_course.id }
    @copy_course = CopyCourseReservesForm.new(user, valid_params)
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

    it "is returns true when it is successful" do
      @reserve = Reserve.factory(FactoryGirl.create(:request, :available), @from_course)
      @from_course.stub!(:reserve).with(@reserve.id).and_return(@reserve)

      valid_params = { course_id: @from_course.id, to_course_id: @to_course.id, reserve_ids: [ @reserve.id ] }
      @copy_course = CopyCourseReservesForm.new(user, valid_params)

      reserves = @copy_course.copy_items()
      reserves.first.id.should_not == @reserve.id
      reserves.first.title.should == @reserve.title
    end


    it "skips reserve ids that are not real reserves" do
      valid_params = { course_id: @from_course.id, to_course_id: @to_course.id, reserve_ids: [  5234234, "a", Object.new ] }
      @copy_course = CopyCourseReservesForm.new(user, valid_params)

      reserves = @copy_course.copy_items()
      reserves.should == []
    end

    it "skips if nothing is passed in" do
      valid_params = { course_id: @from_course.id, to_course_id: @to_course.id }
      @copy_course = CopyCourseReservesForm.new(user, valid_params)

      reserves = @copy_course.copy_items()
      reserves.should == []
    end
  end


  describe :validations do

    it "sends a 404 if the from_course is not found" do
      CopyCourseReservesForm.any_instance.stub(:get_course).with("not_a_course").and_return(nil)
      valid_params = { course_id: 'not_a_course', to_course_id: @to_course.id }

      lambda {
        CopyCourseReservesForm.new(user, valid_params)
      }.should raise_error ActionController::RoutingError
    end


    it "sends a 404 if the to course is not found" do
      CopyCourseReservesForm.any_instance.stub(:get_course).with("not_a_course").and_return(nil)
      valid_params = { course_id: @from_course.id, to_course_id: 'not_a_course' }

      lambda {
        CopyCourseReservesForm.new(user, valid_params)
      }.should raise_error ActionController::RoutingError
    end

    it "sends a 404 if the to course cannot have new reserves added to it" do
      CreateNewReservesPolicy.any_instance.stub(:can_create_new_reserves?).and_return(false)
      valid_params = { course_id: @from_course.id, to_course_id: @to_course.id }

      lambda {
        CopyCourseReservesForm.new(user, valid_params)
      }.should raise_error ActionController::RoutingError
    end
  end
end
