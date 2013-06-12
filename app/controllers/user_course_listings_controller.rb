class UserCourseListingsController < ApplicationController

  layout :determine_layout, :only => :show

  def index
    user_course_listing
  end


  def show
    @user_course_show = UserCourseShow.new(current_user, params)
    check_view_permissions!(@user_course_show.course)
  end


  protected

    def user_course_listing
      @user_course_listing ||= UserCourseListing.new(current_user, params[:semester])
    end

end
