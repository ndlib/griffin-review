require 'spec_helper'

describe DeleteCourseUserForm do

  describe :delete_link do

    before(:each) do
      @course_user = double(CourseUser, user: double(User, id: 1), course: double(Course, id: 2), can_be_deleted?: true )
      @delete_course_user = DeleteCourseUserForm.new(@course_user)
    end

    it "returns a link if the course user can be deleted from the course" do
      @course_user.stub(:can_be_deleted?).and_return(true)
      expect(@delete_course_user.delete_link.include?("<a ")).to be_true
    end

    it "returns empty string if the course user can not be deleted" do
      @course_user.stub(:can_be_deleted?).and_return(false)
      expect(@delete_course_user.delete_link).to be_nil
    end

    it "has a confirmation message" do
      expect(@delete_course_user.delete_link.match("data-confirm=\".*\?\"")).to_not be_nil
    end

  end


  describe :build_from_params do
    before(:each) do
      @course = double(Course, id: 1, enrollments: [], instructors: [])
      @course_users = [ double(CourseUser, id: 2, user: double(User, id: 2), course: @course, can_be_deleted?: true ) ]
      @params = { course_id: "1", id: "2" }

      CourseSearch.any_instance.stub(:get).and_return(@course)
    end


    it "finds the course_user from the course_id and user_id is an enrollment" do
      @course.stub(:enrollments).and_return(@course_users)
      dcu = DeleteCourseUserForm.build_from_params(@params)

      expect(dcu.course_user.id).to eq(@course_users.first.id)
    end


    it "finds the course user from the course_id and user_id is an instrucor" do
      @course.stub(:instructors).and_return(@course_users)
      dcu = DeleteCourseUserForm.build_from_params(@params)

      expect(dcu.course_user.id).to eq(@course_users.first.id)
    end


    it "renders a 404 if the user is not found" do
      @course.stub(:enrollments).and_return(@course_users)
      @params[:id] = 4

      expect { DeleteCourseUserForm.build_from_params(@params) }.to raise_error ActionController::RoutingError
    end

  end


  describe :destroy do
    before(:each) do
      @course_user = double(CourseUser, user: double(User, id: 1), course: double(Course, id: 2), can_be_deleted?: true )
      @delete_course_user = DeleteCourseUserForm.new(@course_user)
    end


    it "destroys a course user that can be deleted" do
      @course_user.stub(:can_be_deleted?).and_return(true)

      course_exception = double(UserCourseException, id: 2)
      @delete_course_user.stub(:course_user_exception).and_return(course_exception)

      expect(course_exception).to receive(:destroy)
      @delete_course_user.destroy
    end


    it "does not destroy a course user that can't be deleted " do
      @course_user.stub(:can_be_deleted?).and_return(false)

      expect { @delete_course_user.destroy }.to raise_error ActionController::RoutingError
    end

  end
end
