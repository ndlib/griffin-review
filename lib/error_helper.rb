module ErrorHelper
  
  def catch_404(exception=nil)
    @masquerading_user = log_error(exception)
    respond_to do |format|
      format.html { render :template => 'errors/error_404', :status => 404 }
    end
  end


  def catch_500(exception=nil)
    @masquerading_user = log_error(exception)
    respond_to do |format|
      format.html { render :template => 'errors/error_404', :status => 404 }
    end
  end

  def log_error(exception)
    @e = env["action_dispatch.exception"]
    masquerading_user = determine_masquerade
    if exception.blank?
      ErrorLog.log_error(current_user, request, @e, masquerading_user)
      Rails.logger.warn(DateTime.now.to_s + " [ERROR RAISED] #{@e.class.to_s} #{@e.message} " + current_user.username)
    else
      ErrorLog.log_error(current_user, request, exception, masquerading_user)
      Rails.logger.warn(DateTime.now.to_s + " [ERROR RAISED] #{exception.inspect} " + current_user.username)
    end
    return masquerading_user
  end

  def determine_masquerade
    masquerade = Masquerade.new(self)
    if masquerade.masquerading?
      masquerade.original_user
    end
  end

end
