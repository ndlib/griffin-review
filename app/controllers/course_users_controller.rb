class CourseUsersController < ApplicationController

  layout :determine_layout


  def index
    check_admin_or_admin_masquerading_permission!
    @course_user_list = CourseUserList.new(current_user, params)
  end


  def new
    check_admin_or_admin_masquerading_permission!
    @add_user_from = AddUserExeceptionForm.new(current_user, params)
  end


  def create
    check_admin_or_admin_masquerading_permission!
    @add_user_from = AddUserExeceptionForm.new(current_user, params)

    if @add_user_from.save_user_exception
      flash[:notice] = "Missing Roster Added"
      redirect_to course_users_path(@add_user_from.course.id)
    else
      flash[:error] = "Unable to add missing roster.  Check the form below and correct any errors"
      render :new
    end
  end


  def destroy
    check_admin_or_admin_masquerading_permission!

    delete_course_user_form = DeleteCourseUserForm.build_from_params(params)

    if delete_course_user_form.destroy
      flash[:notice] = "Roster removed from the course."
    else
      flash[:error] = 'Unable to delete the roster. '
    end

    redirect_to course_users_path(params[:course_id])
  end
end
