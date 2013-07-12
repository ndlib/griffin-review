class ApplicationController < ActionController::Base
  before_filter :authenticate_user!

  protect_from_forgery

 unless Rails.configuration.consider_all_requests_local
    rescue_from CanCan::AccessDenied do |exception|
      redirect_to external_not_authorized_url, :alert => exception.message
    end
    rescue_from Exception, :with => :render_500
    rescue_from ActionController::RoutingError, :with => :render_404
    rescue_from ActionController::UnknownController, :with => :render_404
    rescue_from AbstractController::ActionNotFound, :with => :render_404
    rescue_from ActiveRecord::RecordNotFound, :with => :render_404
  else
    rescue_from CanCan::AccessDenied do |exception|
      redirect_to external_not_authorized_url, :alert => exception.message
    end
  end

  protected

    def determine_layout
      params[:sakai] == '1' ? 'sakai' : 'application'
    end


    def permission
      @permission ||= Permission.new(current_user, self)
    end


    def check_view_permissions!(course)
      if course.nil?
        render_404
      end

      if !permission.current_user_instructs_course?(course) && !permission.current_user_enrolled_in_course?(course)
        render_404
      end
    end


    def check_instructor_permissions!(course)
      if course.nil?
        render_404
      end

      if !permission.current_user_instructs_course?(course)
        render_404
      end
    end


    def check_admin_permission!
      if !permission.current_user_is_administrator?
        render_404
      end
    end


    def check_admin_or_admin_masquerading_permission!
      if !(permission.current_user_is_admin_in_masquerade? || permission.current_user_is_administrator?)
        render_404
      end
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
