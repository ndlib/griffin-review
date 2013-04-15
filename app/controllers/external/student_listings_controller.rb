class StudentListingsController < ApplicationController

  layout 'external'

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
    @student_reserves ||= StudentReserves.new("USER", "SEMESTER")
  end
end
