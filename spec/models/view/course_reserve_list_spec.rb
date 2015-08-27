require 'spec_helper'

describe CourseReserveList do
  let(:user) { double(User, :username => 'student', admin?: false) }

  before(:each) do
    @course = double(Course, :id => 1, :title => 'title', :primary_instructor => double(User, display_name: 'name', admin?: false), :instructor_netids => [], :enrollment_netids => [])
    CourseReserveList.any_instance.stub(:get_course).with("course_id").and_return(@course)

    @user_course_show = CourseReserveList.new(@course, user)
  end

  describe :build_from_params do
    it "raises an error if the course is not found" do
      CourseSearch.any_instance.stub(:get).with("not_a_course_id").and_return(nil)
      controller = double(ApplicationController, current_user: user, params: { course_id: 'not_a_course_id' })

      lambda {
        @user_course_show = CourseReserveList.build_from_params(controller)
      }.should raise_error ActionController::RoutingError
    end
  end



  it "has a title" do
    @user_course_show.respond_to?(:title).should be_true
    @user_course_show.title.should == "title"
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

    it "returns the partial for the enrollment if the user can view all courses" do
      @user_course_show.stub(:can_view_all_courses?).and_return(true)

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

    it "returns only the published_reserves when the user can view all courses" do
      @user_course_show.stub(:can_view_all_courses?).and_return(true)
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
