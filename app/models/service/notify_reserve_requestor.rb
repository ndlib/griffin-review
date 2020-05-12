class NotifyReserveRequestor

  def self.notify
    NotifyReserveRequestor.new.notify
  end


  def notify
    params = Hash.new
    @email_info = Hash.new
    params[:time_delta] = Time.now - 24.hours
    params[:state_type] = 'available'
    params[:item_type] = 'VideoReserve'
    Request.select(:id, :item_title, :course_id)
    .where("workflow_state_change_date >= ? AND workflow_state = ? AND item_type = ?", params[:time_delta], params[:state_type], params[:item_type])
    .collect do |req|
      # email the course primary instructor and not the request requestor
      # since staff enter some request on behalf of the instructor
      course = CourseSearch.new.get(req.course_id)
      if course.primary_instructor
        netid = course.primary_instructor.username
        if @email_info.key?(netid)
          @email_info[netid]['requests'] << req.item_title
        else
          @email_info[netid] = Hash.new
          @email_info[netid]['email'] = course.primary_instructor.email
          @email_info[netid]['display_name'] = course.primary_instructor.display_name
          @email_info[netid]['requests'] = [req.item_title]
        end
      else
        p "ERROR: No primary instructor found for request id " + req.id.to_s + " belonging to course id " + req.course_id
      end
    end
    ReserveMailer.published_request_notifier(@email_info).deliver_now
  end

end
