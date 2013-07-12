class CourseSearchController < ApplicationController

  def index
    @admin_course_listing = AdminCourseListing.new(current_user, params)
  end

end
