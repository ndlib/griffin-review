class CourseSearchController < ApplicationController

  def index
    check_admin_permission!
    @admin_course_listing = CourseSearchList.new(self)
  end

end
