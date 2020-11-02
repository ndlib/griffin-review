require 'error_helper'

class ApplicationController < ActionController::Base
  include ErrorHelper

  before_filter :authenticate_user!, :except => [:catch_500, :catch_404]
  before_filter :set_access_control_headers

  before_filter :log_additional_data

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


  def current_path_is_sakai?
    request.path.starts_with?('/sakai')
  end


  def add_flash(type, msg, now = false)
    if now
      flash.now[type] = msg
    else
      flash[type] = msg
    end
  end


  protected

    def authenticate_user!
      if session[:netid]
        super
      else
        redirect_to user_oktaoauth_omniauth_authorize_path()
      end
    end

    def determine_layout
      current_path_is_sakai? ? 'sakai' : 'application'
    end


    def permission
      @permission ||= Permission.new(current_user, self)
    end


    def check_view_permissions!(course)
      if course.nil?
        raise_404("Course does not exist")
      end

      if ((!permission.current_user_instructs_course?(course) && !permission.current_user_enrolled_in_course?(course)) &&
        !permission.current_user_is_administrator? &&
        !permission.current_user_views_all_courses?)

        raise_404("User cannot view the course")
      end
    end


    def check_instructor_permissions!(course)
      if course.nil?
        raise_404("Course does not exist.")
      end

      if !permission.current_user_instructs_course?(course) && !permission.current_user_is_administrator?
        raise_404("User not an instructor")
      end
    end


    def check_admin_permission!
      if !permission.current_user_is_administrator?
        raise_404("User not an admin")
      end
    end


    def check_admin_or_admin_masquerading_permission!
      if !(permission.current_user_is_admin_in_masquerade? || permission.current_user_is_administrator?)
        raise_404("User not a admin or an admin in masquerade")
      end
    end


    def raise_404(message = "Not Found")
      raise ActionController::RoutingError.new(message)
    end


    def set_access_control_headers
      headers['X-Frame-Options'] = "ALLOW-FROM " + Rails.configuration.sakai_domain
    end


    def log_additional_data
      request.env["exception_notifier.exception_data"] = {
        :netid => (current_user ? current_user.username : ''),
        :location => current_path_is_sakai? ? 'sakai' : 'library'
      }

      if current_user && current_user.wse_admin?
        Rack::MiniProfiler.authorize_request
      end
    end

  private

    # Overwriting the sign_out redirect path method
    def after_sign_out_path_for(resource_or_scope)
      Rails.application.secrets.okta["logout_url"]
    end

    def render_404
      respond_to do |format|
        format.html { render :file => Rails.root.join("public","404.html"), :status => "404 Not Found"}
        format.json { render :nothing => true, :status => "404 Not Found"}
      end
    end

end
