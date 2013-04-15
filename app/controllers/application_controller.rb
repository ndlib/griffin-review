class ApplicationController < ActionController::Base
  protect_from_forgery


  helper HesburghAssets::AssetsHelper

  # before_filter :authenticate_user!

  protected

  def render_404
    respond_to do |format|
      format.html { render :template => 'errors/error_404', :layout => 'layouts/external', :status => 404 }
      format.all { render :nothing => true, :status => 404 }
    end
  end


  def render_500(exception)
    @error = exception
    respond_to do |format|
      format.html { render :template => 'errors/error_500', :layout => 'layouts/external', :status => 500 }
      format.all { render :nothing => true, :status => 500}
    end
  end

end
