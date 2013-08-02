class CourseSearchController < ApplicationController

  def index
    check_admin_permission!
    @admin_course_listing = AdminCourseList.new(current_user, params)
  end

end
