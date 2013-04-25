class GetReservesController < ApplicationController

  layout 'external'


  def show
    @course_listing = course.get_reserve(params[:id])

    if params[:accept_terms_of_service]
      @course_listing.approve_terms_of_service!
    end

    if @course_listing.approval_required?
      return

    elsif @course_listing.download_listing?
      send_file(@course_listing.download_file_path)

    elsif @course_listing.redirect_to_listing?
      redirect_to @course_listing.redirect_uri

    else

      raise "Attempt to get the resource of a listing that cannot be downloaded or redirected to. "
    end
  end


  protected

    def reserves
      @reserves ||= ReservesApp.new("USER")
    end


    def course
      @course ||= reserves.course("1")
    end

end
