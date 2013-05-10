class StudentListingsController < ApplicationController

  def index
    reserves
  end


  def show
    @course = reserves.course(params[:id])

    if @course.nil?
      render_404
    end
  end


  protected

    def reserves
      @reserves ||= ReservesApp.new(current_user)
    end

end
