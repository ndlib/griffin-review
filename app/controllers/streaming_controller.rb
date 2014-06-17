class StreamingController < ApplicationController

  skip_before_filter :authenticate_user!


  def show
    @get_reserve = GetReserve.new(self)

    authenticate_user!
    check_view_permissions!(@get_reserve.course)
  end


  protected

  def valid_token?
    (@get_reserve.get_course_token == params[:token])
  end

end
