class CopyReserve


  def initialize(current_user, course_to, reserve)
    @user = current_user
    @course_to = course_to
    @reserve = reserve
  end


  def copy
    new_request = @reserve.request.dup

    new_request.course_id = @course_to.id
    new_request.crosslist_id = @course_to.crosslist_id

    new_request.workflow_state = 'new'

    new_request.semester  = @course_to.semester
    new_request.topics    = []
    new_request.save!

    @reserve.fair_use.copy_to_new_request!(new_request, @user)

    new_request
  end

end
