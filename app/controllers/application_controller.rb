require 'error_helper'

class ApplicationController < ActionController::Base
  include ErrorHelper

  before_filter :authenticate_user!
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
  end

  protected

    def determine_layout
      current_path_is_sakai? ? 'sakai' : 'application'
    end


    def permission
      @permission ||= Permission.new(current_user, self)
    end


    def check_view_permissions!(course)
      if course.nil?
        raise_404
      end

      if (!permission.current_user_instructs_course?(course) && !permission.current_user_enrolled_in_course?(course)) && !permission.current_user_is_administrator?
        raise_404
      end
    end


    def check_instructor_permissions!(course)
      if course.nil?
        raise_404
      end

      if !permission.current_user_instructs_course?(course) && !permission.current_user_is_administrator?
        raise_404
      end
    end


    def check_admin_permission!
      if !permission.current_user_is_administrator?
        raise_404
      end
    end


    def check_admin_or_admin_masquerading_permission!
      if !(permission.current_user_is_admin_in_masquerade? || permission.current_user_is_administrator?)
        raise_404
      end
    end


    def raise_404
      raise ActionController::RoutingError("Not Found")
    end


    def set_access_control_headers
      headers['X-Frame-Options'] = "ALLOW-FROM " + Rails.configuration.sakai_domain
    end


    def log_additional_data
      request.env["exception_notifier.exception_data"] = {
        :netid => (current_user ? current_user.username : ''),
        :location => current_path_is_sakai? ? 'sakai' : 'library'
      }
    end


    def current_path_is_sakai?
      request.path.starts_with?('/sakai')
    end

end
