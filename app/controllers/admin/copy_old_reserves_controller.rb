class Admin::CopyOldReservesController  < ApplicationController


  def new
    @copy_old_course_reserve = CopyOldCourseReservesForm.new(current_user, params)
  end


  def create
    @copy_old_course_reserve = CopyOldCourseReservesForm.new(current_user, params)

    if @copy_old_course_reserve.copy!
      redirect_to course_path(copy_old_course_reserve.to_course.id)
      return
    end
  end

end
