class ErrorLog  < ActiveRecord::Base

  scope :default_order, -> { order("created_at DESC") }

  def self.log_error(controller, exception)
    error = ErrorLog.create(
      message: determine_message(exception),
      netid: write_netid_text(controller),
      path: controller.request.path,
      params: controller.request.params.to_s,
      stack_trace: determine_backtrace(exception)
    )

    Rails.logger.warn(DateTime.now.to_s + " [ERROR RAISED] http://reserves.library.nd.edu:/errors/#{error.id}")

    error
  end


  def self.errors
    self.default_order.limit(100)
  end


  def self.determine_netid(controller)
    if controller.current_user.present?
       controller.current_user.username
    else
      "Uknown User"
    end
  end


  def self.write_netid_text(controller)
    if masquerading_username = determine_masquerade(controller)
      "#{masquerading_username} (as: #{determine_netid(controller)})"
    else
      determine_netid(controller)
    end
  end


  def self.determine_message(exception)
    exception.blank? ? 'Nil Exception' : exception.message
  end


  def self.determine_backtrace(exception)
    if exception.blank?
      'Nil Exception'
    elsif exception.backtrace.nil?
      "No Backtrace"
    else
      exception.backtrace.join("\n")
    end

  end


  def self.determine_masquerade(controller)
    masquerade = Masquerade.new(controller)
    if masquerade.masquerading?
      return masquerade.original_user.username
    end

    return false
  end
end
