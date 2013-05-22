class InstructorNewReservesController < ApplicationController

  def new
    check_instructor_permissions!(course)

    @request_reserve = InstructorReserveRequest.new(current_user, course)
  end


  def create
    check_instructor_permissions!(course)

    flash[:success] = "<h4>New Request Made</h4><p> Your request has been recieve and will be processed as soon as possible.  </p><a href=\"#{course_path(course.id)}\" class=\"btn btn-primary\">I am Done</a>"

    redirect_to new_course_reserve_path(course.id)
  end


  protected

    def user_course_listing
      @user_course_listing ||= UserCourseListing.new(current_user)
    end


    def course
      @course ||= user_course_listing.course(params[:course_id])
    end
end
