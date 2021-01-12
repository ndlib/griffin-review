class MultideleteRequestsController < ApplicationController
  def destroy
    check_instructor_permissions!(CourseSearch.new.get(params['course_id']))
    num_ids = 0
    if params[:request_ids].present?
      num_ids = params[:request_ids].length
      params[:request_ids].each do |id|
        Request.update(id, workflow_state: 'removed')
      end
    end

    if num_ids > 0
      flash[:success] = "Removed #{num_ids} request(s)."
    else
      flash[:notice] = "Please select request(s) to remove and try again"
    end
    redirect_to course_reserves_path(params['course_id'])
  end
end
