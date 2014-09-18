class StreamingController < ApplicationController


  def show
    @get_reserve = GetStreamingReserve.new(self)
    check_view_permissions!(@get_reserve.course)
  end

end
