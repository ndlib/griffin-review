class ExternalController < ApplicationController

  before_filter :authenticate_user!
  load_and_authorize_resource
  skip_authorize_resource :only => :not_authorized

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to external_not_authorized_url, :alert => exception.message
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
