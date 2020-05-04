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
    Request.select(:item_title, :requestor_netid)
    .where("workflow_state_change_date >= ? AND workflow_state = ? AND item_type = ?", params[:time_delta], params[:state_type], params[:item_type])
    .collect do |r|
      netid = r.requestor_netid
      if @email_info.key?(netid)
        @email_info[netid]['requests'] << r.item_title
      else
        @user = User.where(:username => netid).first
        @email_info[netid] = Hash.new
        @email_info[netid]['email'] = @user.email
        @email_info[netid]['display_name'] = @user.display_name
        @email_info[netid]['requests'] = [r.item_title]
      end
    end
    ReserveMailer.published_request_notifier(@email_info).deliver_now
  end

end
