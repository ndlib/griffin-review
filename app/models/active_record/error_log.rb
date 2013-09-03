class ErrorLog  < ActiveRecord::Base

  scope :default_order, -> { order(:created_at) }

  def self.log_error(current_user, request, exception)
    ErrorLog.create(message: exception.message, netid: current_user.username, path: request.path, params: request.params.to_s, stack_trace: exception.backtrace.to_s )
  end


  def self.errors
    self.default_order.limit(100)
  end


end
