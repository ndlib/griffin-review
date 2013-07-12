class CoursesController < ApplicationController

  def index
    @user_course_listing = UserCourseListing.new(current_user)
  end


  def create
    course = CourseSearch.new.get(params[:course_id])

    Reserve.generate_test_data_for_course(course)

    redirect_to course_reserves_path(course.id)
  end

end
