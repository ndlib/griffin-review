class InstructorNewReservesController < ApplicationController

  def new
    check_instructor_permissions!(course)

    @new_reserve = InstructorReserveRequest.new(current_user, course)
  end


  def create
    check_instructor_permissions!(course)

    @request_reserve = InstructorReserveRequest.new(current_user, course, params[:instructor_reserve_request])

    if @request_reserve.make_request
      flash[:success] = "<h4>New Request Made</h4><p> Your request has been recieve and will be processed as soon as possible.  </p><a href=\"#{course_path(course.id)}\" class=\"btn btn-primary\">I am Done</a>"

      redirect_to new_course_reserve_path(course.id)
      return
    else

      @new_reserve = InstructorReserveRequest.new(current_user, course)

      flash.now[:error] = "Your form submission has errors in it.  Please correct them and resubmit."
    end


    render :new
  end


  protected

    def user_course_listing
      @user_course_listing ||= UserCourseListing.new(current_user)
    end


    def course
      @course ||= CourseSearch.new.get(params[:course_id])
    end


    def check_if_course_can_have_new_reserves!(course)
      if !CreateNewReservesPolicy.new(course).can_create_new_reserves?
        render_404
      end
    end
end
