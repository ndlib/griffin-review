module ErrorHelper

  def catch_404(exception=nil)
    @masquerading_user = determine_masquerade
    log_error(exception)

    respond_to do |format|
      format.html { render :template => 'errors/error_404', :status => 404 }
    end
  end


  def catch_500(exception=nil)
    @masquerading_user = determine_masquerade
    log_error(exception)

    if !exception.nil?
      ExceptionNotifier.notify_exception(exception, { :env => request.env })
    end

    respond_to do |format|
      format.html { render :template => 'errors/error_404', :status => 500 }
    end
  end


  def log_error(exception)
    @e = env["action_dispatch.exception"]
    if exception.blank?
      ErrorLog.log_error(self, @e)
    else
      ErrorLog.log_error(self, exception)
    end
  end


  def determine_masquerade
    masquerade = Masquerade.new(self)
    if masquerade.masquerading?
      return masquerade.original_user
    end

    return false
  end

end
