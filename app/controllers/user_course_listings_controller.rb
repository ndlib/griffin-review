class UserCourseListingsController < ApplicationController

  layout :determine_layout, :only => :show

  def index
    user_course_listing
  end


  def show
    @course = user_course_listing.course(params[:id])
    check_view_permissions!(@course)
  end


  protected

    def user_course_listing
      @user_course_listing ||= UserCourseListing.new(current_user, params[:semester])
    end

end
