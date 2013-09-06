class ErrorLog  < ActiveRecord::Base

  scope :default_order, -> { order("created_at DESC") }

  def self.log_error(current_user, request, exception, masquerading_user = "")
    ErrorLog.create(
      message: determine_message(exception),
      netid: determine_netid(current_user, masquerading_user),
      path: request.path,
      params: request.params.to_s,
      stack_trace: determine_backtrace(exception)
    )
  end


  def self.errors
    self.default_order.limit(100)
  end


  def self.determine_netid(current_user, masquerading_user)
    if current_user.present?
      masquerading_user.blank? ? current_user.username : "#{masquerading_user.username} (as: " + current_user.username + ")"
    else
      "Uknown User"
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
end
