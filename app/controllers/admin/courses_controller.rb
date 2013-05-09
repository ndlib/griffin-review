class CoursesController < ApplicationController


  def index
    @courses = false

    if params[:netid]
      @courses = reserves.netid_instructed_courses(params[:netid], 'semester')
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
