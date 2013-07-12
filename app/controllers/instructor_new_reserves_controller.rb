class InstructorNewReservesController < ApplicationController

  def new
    @new_reserve = InstructorReserveRequest.new(current_user, params)

    check_instructor_permissions!(@new_reserve.course)
  end


  def create
    @request_reserve = InstructorReserveRequest.new(current_user, params)

    check_instructor_permissions!(@request_reserve.course)

    if @request_reserve.make_request
      flash[:success] = "<h4>New Request Made</h4><p> Your request has been recieve and will be processed as soon as possible.  </p><a href=\"#{course_reserves_path(@request_reserve.course.id)}\" class=\"btn btn-primary\">I am Done</a>"

      redirect_to new_course_reserve_path(@request_reserve.course.id)
      return
    else

      @new_reserve = InstructorReserveRequest.new(current_user, params)

      flash.now[:error] = "Your form submission has errors in it.  Please correct them and resubmit."
    end


    render :new
  end


  protected


    def check_if_course_can_have_new_reserves!(course)
      if !CreateNewReservesPolicy.new(course).can_create_new_reserves?
        render_404
      end
    end
end
