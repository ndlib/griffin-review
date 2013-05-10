class CoursesController < ApplicationController

  layout 'admin'

  def index
    @courses = false

    if params[:netid]
      @courses = reserves.netid_instructed_courses(params[:netid], '201210')
    end

  end


  def show
    @course = reserves.course(params[:id])
  end


  protected

    def reserves
      @reserves ||= ::ReservesAdminApp.new(params[:semester], "current_user")
    end



end
