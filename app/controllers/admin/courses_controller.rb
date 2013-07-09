class Admin::CoursesController < ApplicationController

  def index
    @admin_course_listing = AdminCourseListing.new(current_user, params)
  end


  def show
    @course = reserves.course(params[:id], params[:netid])
  end


  protected

    def reserves
      @reserves ||= ::ReservesAdminApp.new(params[:semester], current_user)
    end



end
