class UserCourseListingsController < ApplicationController

  def index
    user_course_listing
  end


  def show
    @course = user_course_listing.course(params[:id])
    check_view_permissions!(@course)
  end


  protected

    def user_course_listing
      @user_course_listing ||= UserCourseListing.new(current_user)
    end


    def check_view_permissions!(course)
      if course.nil?
        render_404
      end

      if !permission.current_user_instructs_course?(course) && !permission.current_user_enrolled_in_course?(course)
        render_404
      end
    end

end
