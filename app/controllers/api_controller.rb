class ApiController < ActionController::Base
  acts_as_token_authentication_handler_for User, fallback_to_devise: false

  force_ssl if: :ssl_configured?

  def ssl_configured?
    !(Rails.env.development? || Rails.env.test?)
  end

  protect_from_forgery

  unless Rails.configuration.consider_all_requests_local
    rescue_from ActionController::RoutingError, :with => :catch_404
    rescue_from ActionController::UnknownController, :with => :catch_404
    rescue_from AbstractController::ActionNotFound, :with => :catch_404
    rescue_from ActiveRecord::RecordNotFound, :with => :catch_404
    rescue_from Exception, :with => :catch_500
  end


  def courses
    if !UserIsAdminPolicy.new(current_user).is_admin?
      raise_404
    end

    course = CoursesInReserves.new(params[:id])
    render json: course.to_hash
  end

  private

  def raise_404(message = "Not Found")
    raise ActionController::RoutingError.new(message)
  end

end
