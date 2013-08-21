require 'spec_helper'

describe CopyCourseReservesForm do

  let(:user) { mock_model(User, :id => 1, :username => 'instructor') }
  let(:course_search) { CourseSearch.new }

  before(:each) do
    stub_courses!

    semester = FactoryGirl.create(:semester)
    next_semester = FactoryGirl.create(:next_semester)

    @from_course = double(Course, :id => 'from_course_id', :title => 'from title', :primary_instructor => double(User, display_name: 'name'), :crosslist_id => 'from_reserve_id')
    @from_course.stub(:semester).and_return(semester)
    @to_course = double(Course, :id => 'to_course_id', :title => 'to title', :primary_instructor => double(User, display_name: 'name'), :crosslist_id => 'to_reserve_id')
    @to_course.stub(:semester).and_return(next_semester)

    CourseSearch.any_instance.stub(:get).and_return(nil)
    CourseSearch.any_instance.stub(:get).with(@from_course.id).and_return(@from_course)
    CourseSearch.any_instance.stub(:get).with(@to_course.id).and_return(@to_course)

    valid_params = { course_id: @to_course.id, from_course_id: @from_course.id }
    @copy_course = CopyCourseReservesForm.new(user, valid_params)
  end


  it "displays the from course title" do
    @copy_course.from_course_title.should == "#{@from_course.title} - #{@from_course.semester.full_name}"
  end


  it "displays the to course title" do
    @copy_course.to_course_title.should == "#{@to_course.title} - #{@to_course.semester.full_name}"
  end


  describe :copy do

    it "is returns true when it is successful" do
      @reserve = Reserve.factory(FactoryGirl.create(:request, :available), @from_course)
      @from_course.stub(:reserve).with(@reserve.id).and_return(@reserve)

      valid_params = { course_id: @to_course.id, from_course_id: @from_course.id, reserve_ids: [ @reserve.id ] }
      @copy_course = CopyCourseReservesForm.new(user, valid_params)

      reserves = @copy_course.copy_items()
      reserves.first.id.should_not == @reserve.id
      reserves.first.item.title.should == @reserve.item.title
    end


    it "skips reserve ids that are not real reserves" do
      valid_params = { course_id: @to_course.id, from_course_id: @from_course.id, reserve_ids: [  5234234, "a", Object.new ] }
      @copy_course = CopyCourseReservesForm.new(user, valid_params)

      reserves = @copy_course.copy_items()
      reserves.should == []
    end


    it "skips if nothing is passed in" do
      valid_params = { course_id: @to_course.id, from_course_id: @from_course.id }
      @copy_course = CopyCourseReservesForm.new(user, valid_params)

      reserves = @copy_course.copy_items()
      reserves.should == []
    end
  end


  describe :step1? do

    it "returns true if the to course is set and the from course is not " do
      valid_params = { course_id: @to_course.id }
      CopyCourseReservesForm.new(user, valid_params).step1?.should be_true
    end


    it "returns false if the to course is set" do
      valid_params = { course_id: @to_course.id, from_course_id: @from_course.id }
      CopyCourseReservesForm.new(user, valid_params).step1?.should be_false
    end

  end


  describe :step2 do

    it "returns true if both the from course and the to course are set " do
      valid_params = { course_id: @to_course.id, from_course_id: @from_course.id }
      CopyCourseReservesForm.new(user, valid_params).step2?.should be_true
    end

    it "returns false if the the to course is not set " do
      valid_params = { course_id: @to_course.id  }
      CopyCourseReservesForm.new(user, valid_params).step2?.should be_false
    end

  end


  describe :validations do

    it "sends a 404 if the from_course is not found" do
      valid_params = { course_id: 'not_a_course', from_course_id: @from_course.id }

      lambda {
        CopyCourseReservesForm.new(user, valid_params)
      }.should raise_error ActionController::RoutingError
    end


    it "allows only the from_course to be set " do
      valid_params = { course_id: @from_course.id }

      lambda {
        CopyCourseReservesForm.new(user, valid_params)
      }.should_not raise_error ActionController::RoutingError
    end


    it "does fails if there is no from course " do
      valid_params = {  from_course_id: @from_course.id }

      lambda {
        CopyCourseReservesForm.new(user, valid_params)
      }.should raise_error ActionController::RoutingError

    end

    it "sends a 404 if the to course is not found" do
      valid_params = { course_id: @from_course.id, from_course_id: 'not_a_course' }

      lambda {
        CopyCourseReservesForm.new(user, valid_params)
      }.should raise_error ActionController::RoutingError
    end


    it "sends a 404 if the to course cannot have new reserves added to it" do
      CreateNewReservesPolicy.any_instance.stub(:can_create_new_reserves?).and_return(false)
      valid_params = { course_id: @to_course.id, from_course_id: @from_course.id }

      lambda {
        CopyCourseReservesForm.new(user, valid_params)
      }.should raise_error ActionController::RoutingError
    end

  end
end
