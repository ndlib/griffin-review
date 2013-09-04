class ErrorLog  < ActiveRecord::Base

  scope :default_order, -> { order("created_at DESC") }

  def self.log_error(current_user, request, exception, masquerading_user = nil)
    exception_message = exception.blank? ? 'Nil Exception' : exception.message
    current_username = current_user.present? ? current_user.username : 'Unknown User'
    current_username = masquerading_user.blank? ? current_user.username : "#{masquerading_user.username} (as: " + current_user.username + ")"
    exception_backtrace = exception.blank? ? 'Nil Exception' : exception.backtrace.join("\n")
    ErrorLog.create(message: exception_message, netid: current_username, path: request.path, params: request.params.to_s, stack_trace: exception_backtrace )
  end


  def self.errors
    self.default_order.limit(100)
  end


end
