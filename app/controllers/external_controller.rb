class ExternalController < ApplicationController

  before_filter :authenticate_user!
#  load_and_authorize_resource
#  skip_authorize_resource :only => :not_authorized


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

end
