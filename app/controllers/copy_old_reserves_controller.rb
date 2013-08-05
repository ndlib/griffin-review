class CopyOldReservesController  < ApplicationController

  layout :determine_layout

  def new
    check_admin_or_admin_masquerading_permission!
    @copy_old_course_reserve = CopyOldCourseReservesForm.new(current_user, params)
  end


  def create
    check_admin_or_admin_masquerading_permission!
    @copy_old_course_reserve = CopyOldCourseReservesForm.new(current_user, params)

    if @copy_old_course_reserve.copy!
      flash[:success] = "Successfully copied reserves from old reserves "
      redirect_to course_reserves_path(@copy_old_course_reserve.to_course.id)
      return
    end
  end

end
