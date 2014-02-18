class CoursesController < ApplicationController

  layout :determine_layout

  def index
    if permission.current_user_is_administrator?
      @admin_course_listing = CourseSearchList.new(self)
      render 'course_search/index'
    else
      @user_course_listing = ListUsersCourses.build_from_params(self)
      render :index
    end
  end

end
