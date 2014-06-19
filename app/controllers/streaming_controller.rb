class StreamingController < ApplicationController


  def show
    @get_reserve = GetStreamingReserve.new(self)
    check_view_permissions!(@get_reserve.course)
  end


  protected

  def valid_token?
    (@get_reserve.get_course_token == params[:token])
  end

end
