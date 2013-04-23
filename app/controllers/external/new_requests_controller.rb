class NewRequestsController < ApplicationController

  layout 'external'

  def new
    @course = reserves.course(params[:prof_listing_id])
  end


  def create

  end

end
