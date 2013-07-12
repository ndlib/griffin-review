require 'spec_helper'

describe CourseReserveList do
  let(:user) { mock(User, :username => 'student') }

  before(:each) do
    @course = mock(Course, :id => 1, :title => 'title', :instructor_name => 'name')
    CourseReserveList.any_instance.stub(:get_course).with("course_id").and_return(@course)

    @user_course_show = CourseReserveList.new(user, {:course_id => "course_id"})
  end


  it "raises an error if the course is not found" do
    CourseReserveList.any_instance.stub(:get_course).with("not_a_course_id").and_return(nil)

    lambda {
      @user_course_show = CourseReserveList.new(user, {:course_id => "not_a_course_id"})
    }.should raise_error ActionController::RoutingError
  end


  it "has a title" do
    @user_course_show.respond_to?(:title).should be_true
    @user_course_show.title.should == "title"
  end


  it "has an instructor_name" do
    @user_course_show.respond_to?(:instructor_name).should be_true
    @user_course_show.instructor_name.should == "name"
  end


  it "has a course id " do
    @user_course_show.respond_to?(:course_id).should be_true
    @user_course_show.course_id.should == 1
  end


  describe :show_partial do
    it "returns the partial for the enrollment if the user is enrolled in the course" do
      @user_course_show.stub(:enrolled_in_course?).and_return(true)

      @user_course_show.show_partial[:partial].should == 'enrolled_course_show'
      @user_course_show.show_partial[:locals][:user_course_show].should == @user_course_show
    end


    it "returns the partial for instructor if the user instucts the course" do
      @user_course_show.stub(:enrolled_in_course?).and_return(false)
      @user_course_show.stub(:instructs_course?).and_return(true)

      @user_course_show.show_partial[:partial].should == 'instructed_course_show'
      @user_course_show.show_partial[:locals][:user_course_show].should == @user_course_show
    end

  end


  describe "#can_have_new_reserves?" do

    it "returns true if the course can have new reserves added to it" do
      CreateNewReservesPolicy.any_instance.stub(:can_create_new_reserves?).and_return(true)
      @user_course_show.can_have_new_reserves?.should be_true
    end


    it "returns false if the course cannot have new reserves added to it" do
      CreateNewReservesPolicy.any_instance.stub(:can_create_new_reserves?).and_return(false)
      @user_course_show.can_have_new_reserves?.should be_false
    end
  end


  describe "#reserves" do

    it "returns only the published_reserves when the user is enrolled in the couses" do
      @user_course_show.stub(:enrolled_in_course?).and_return(true)
      @course.should_receive(:published_reserves)
      @course.should_not_receive(:reserves)

      @user_course_show.reserves
    end

    it "returns all the reserves when a user instructs the course" do
      @user_course_show.stub(:enrolled_in_course?).and_return(false)
      @user_course_show.stub(:instructs_course?).and_return(true)

      @course.should_not_receive(:published_reserves)
      @course.should_receive(:reserves)

      @user_course_show.reserves
    end
  end
end
