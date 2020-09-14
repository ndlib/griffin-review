class MultideleteRequestsController < ApplicationController
  def destroy
    check_instructor_permissions!(CourseSearch.new.get(params['course_id']))
    params[:request_ids].each do |id|
      Request.update(id, workflow_state: 'removed')
    end
    redirect_to course_reserves_path(params['course_id'])
  end
end
