class ProfListingsController < ApplicationController

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

end
