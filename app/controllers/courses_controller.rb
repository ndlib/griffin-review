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

  # export physical available course reserves
  def export_csv
    check_admin_permission!
    course_id = params[:course_id]
    ce = CourseExporter.new(course_id)
    send_data(ce.course_content, :filename => "#{course_id}.csv")
  end

end
