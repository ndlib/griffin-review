class RequestReservesController < ApplicationController

  def new
    @request_reserve = InstructorReserveRequest.new(course.new_reserve(), current_user)
  end


  def create

  end


  protected

    def reserves
      @reserves ||= ReservesApp.new("USER")
    end


    def course
      @course ||= reserves.course(params[:prof_listing_id])
    end
end
