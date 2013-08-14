class CourseUsersController < ApplicationController


  def new
    check_admin_or_admin_masquerading_permission!
    @add_user_from = AddUserExeceptionForm.new(current_user, params)
  end


  def create
    check_admin_or_admin_masquerading_permission!
    @add_user_from = AddUserExeceptionForm.new(current_user, params)

    if @add_user_from.save_user_exception
      flash[:notice] = "Missing User Added"
      redirect_to course_reserves_path(@add_user_from.course.id)
    else
      flash[:error] = "Unable to add missing user.  Check the form below and correct any errors"
      render :new
    end
  end

end
