class RequestsFixMissingCoursesController  < ApplicationController

  def edit
    check_admin_permission!
    @request = RequestFixMissingCourseForm.build_from_params(self)
  end


  def update
    check_admin_permission!
    @request = RequestFixMissingCourseForm.build_from_params(self)

    if @request.update_course_id!
      redirect_to request_path(@request.id)
    else
      render :edit
    end
  end

end
