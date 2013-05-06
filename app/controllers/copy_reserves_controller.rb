class CopyReservesController < ApplicationController

  layout 'external'


  def create
    @copy_course_listing = reserves.copy_course_listing(params[:prof_listing_id], params[:prof_listing_id])

    if !@copy_course_listing.copy_items([])

    end

    flash[:notice] = "Material Copied Successfully"
  end


  protected

    def reserves
      @reserves ||= ReservesApp.new("USER")
    end

end
