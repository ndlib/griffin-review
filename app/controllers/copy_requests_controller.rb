class CopyRequestsController < ApplicationController
  def new
    reserve = ReserveSearch.new.get(params[:id])
    course = CourseSearch.new.get(reserve.course_id)
    if reserve && reserve.can_copy_reserve?
      res = CopyReserve.new(current_user, course, reserve).copy
      flash[:success] = 'Request Copy Success - This is the requested copy.'
      redirect_to request_path(res.id)
    else
      flash[:notice] = "Cannot copy request in a 'removed' state."
      redirect_to '/'
    end
  end
end
