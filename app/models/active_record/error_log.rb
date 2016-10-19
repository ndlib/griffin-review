class ErrorLog  < ActiveRecord::Base

  scope :default_order, -> { order("state DESC, created_at DESC") }

  # the state_machine gem is no longer maintained and initial values are broken in rails 4.2. This is a work around.
  # see https://github.com/pluginaweek/state_machine/issues/334
  after_initialize :set_initial_status
  def set_initial_status
    self.state ||= :new
  end

  state_machine :state, :initial => :new do

    event :resolve do
      transition [:new, :active] => :resolved
    end

    event :start do
      transition [:new] => :active
    end

    state :new
    state :active
    state :resolved
  end


  def self.log_error(controller, exception)
    error = ErrorLog.create(
      message: determine_message(exception),
      netid: write_netid_text(controller),
      path: controller.request.path,
      params: controller.params.to_s,
      exception_class: determine_exception_class(exception),
      user_agent: controller.request.user_agent,
      stack_trace: determine_backtrace(exception)
    )

    Rails.logger.warn(DateTime.now.to_s + " [ERROR RAISED] http://reserves.library.nd.edu/errors/#{error.id}")

    error
  end


  def self.log_message(netid, text)
    error = ErrorLog.create(
      message: text,
      netid: netid,
      path: "",
      params: "",
      exception_class: "",
      user_agent: "",
      stack_trace: ""
    )
  end

  def self.errors
    self.default_order.limit(100).where("state != ? ", 'resolved')
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


  def self.determine_exception_class(exception)
    if exception.blank?
      "No Exception Thrown"
    else
      exception.class.to_s
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
