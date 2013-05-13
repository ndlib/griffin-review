class ApplicationController < ActionController::Base
  before_filter :authenticate_user!

  protect_from_forgery

  helper HesburghAssets::AssetsHelper

  protected

    def permission
      @permission ||= Permission.new(current_user)
    end


    def render_404
      raise ActionController::RoutingError.new('Not Found')
    end


    def render_500(exception)
      @error = exception
      respond_to do |format|
        format.html { render :template => 'errors/error_500', :layout => 'layouts/external', :status => 500 }
        format.all { render :nothing => true, :status => 500}
      end
    end

end
