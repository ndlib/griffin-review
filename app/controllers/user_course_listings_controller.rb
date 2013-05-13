class UserCourseListingsController < ApplicationController

  def index
    user_course_listing
  end


  def show
    @course = user_course_listing.course(params[:id])

    if @course.nil?
      render_404
    end
  end


  protected

    def user_course_listing
      @user_course_listing ||= UserCourseListing.new(current_user)
    end


end
