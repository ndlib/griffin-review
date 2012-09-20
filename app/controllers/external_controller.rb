class ExternalController < ApplicationController

  before_filter :authenticate_user!
  load_and_authorize_resource
  skip_authorize_resource :only => :not_authorized

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to external_not_authorized_url, :alert => exception.message
  end

  unless Rails.configuration.consider_all_requests_local
    rescue_from Exception, :with => :render_500
    rescue_from ActionController::RoutingError, :with => :render_404
    rescue_from ActionController::UnknownController, :with => :render_404
    rescue_from AbstractController::ActionNotFound, :with => :render_404
    rescue_from ActiveRecord::RecordNotFound, :with => :render_404
  end

  def index

    page_title = "Reserves"

    respond_to do |format|
      format.html
    end

  end

  def not_authorized

    respond_to do |format|
      format.html
    end

  end

  private
  def render_404(exception)
    @not_found_path = exception.message
    respond_to do |format|
      format.html { render :template => 'errors/error_404', :layout => 'layouts/external', :status => 404 }
      format.all { render :nothing => true, :status => 404 }
    end
  end

  def render_500(exception)
    @error = exception
    logger.debug "500 ERROR: " + exception.inspect + " in " + exception.class.to_s
    respond_to do |format|
      format.html { render :template => 'errors/error_500', :layout => 'layouts/external', :status => 500 }
      format.all { render :nothing => true, :status => 500}
    end
  end

end
