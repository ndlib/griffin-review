class InstructorNewReservesController < ApplicationController

  def new
    check_instructor_permissions!(course)

    @request_reserve = InstructorReserveRequest.new(course.new_reserve(), current_user)
  end


  def create
    check_instructor_permissions!(course)
  end


  protected

    def user_course_listing
      @user_course_listing ||= UserCourseListing.new(current_user)
    end


    def course
      @course ||= user_course_listing.course(params[:course_id])
    end
end
