class CopyRequestsController < ApplicationController

  layout 'external'


  def create
    from_course = reserves.course(params[:prof_listing_id])
    to_course = reserves.course(params[:prof_listing_id])
    @copy_requests = CopyCourseListings.new(from_course, to_course)

    if !@copy_requests.copy_items([])

    end

    flash[:notice] = "Material Copied Successfully"

  end

  protected

    def reserves
      @reserves ||= Reserves.new("USER", "SEMESTER")
    end
end
