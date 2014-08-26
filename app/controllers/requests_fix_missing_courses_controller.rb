class RequestsFixMissingCoursesController  < ApplicationController

  def edit
    check_admin_permission!
    @request = RequestFixMissingCourseForm.build_from_params(self)
  end


  def update
    check_admin_permission!
    @request = RequestFixMissingCourseForm.build_from_params(self)

    if @request.update_course_id!
      flash[:success] = t("successes.messages.fix_missing_courses", old_course_id: @request.old_course_id, new_course_id: @request.new_course_id)
      redirect_to request_path(@request.id)
    else
      flash.now[:error] = t('errors.messages.form_error')
      render :edit
    end
  end

end
