class CopyReserve

  def initialize(current_user, course_to, reserve)
    @user = current_user
    @course_to = course_to
    @reserve = reserve
  end


  def copy(*new_item_flag)
    new_request = @reserve.request.dup

    new_request.created_at = Time.now
    new_request.updated_at = Time.now

    new_request.needed_by = 2.weeks.from_now

    new_request.course_id = @course_to.id
    new_request.workflow_state = 'new'
    new_request.semester  = @course_to.semester

    new_request.requestor_netid = @user.username

    if @course_to.semester.id == @reserve.course.semester.id
        new_request.currently_in_aleph = @reserve.currently_in_aleph
    else
        new_request.currently_in_aleph = false
    end

    if new_item_flag.any?
        new_request.item = @reserve.request.item.dup
    end

    new_request.save!

    @reserve.fair_use.copy_to_new_request!(new_request, @user)

    res = Reserve.factory(new_request)

    ReserveCheckIsComplete.new(res).check!

    res
  end

end
