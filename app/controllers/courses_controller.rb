class CoursesController < ApplicationController

  layout :determine_layout

  def index
    if permission.current_user_is_administrator?
      @admin_course_listing = AdminCourseList.new(current_user, params)
      render 'course_search/index'
    else
      @user_course_listing = UserCourseListing.new(current_user)
      render :index
    end
  end


  def create
    course = CourseSearch.new.get(params[:course_id])

    Reserve.generate_test_data_for_course(course)

    redirect_to course_reserves_path(course.id)
  end

end
