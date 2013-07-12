class UserCourseListingsController < ApplicationController

  layout :determine_layout, :only => :show

  def index
    @user_course_listing = UserCourseListing.new(current_user)
  end


  def create
    course = CourseSearch.new.get(params[:course_id])

    Reserve.generate_test_data_for_course(course)

    redirect_to course_path(course.id)
  end


  def destroy

  end
end
