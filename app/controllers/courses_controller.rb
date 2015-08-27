class CoursesController < ApplicationController

  layout :determine_layout

  def index
    if permission.current_user_is_administrator? || permission.current_user_views_all_courses?
      @admin_course_listing = SearchCourses.new(self)
      render 'course_search/index'
    else
      @user_course_listing = ListUsersCourses.build_from_params(self)
      render :index
    end
  end

end
