module RailsHelpers

  protected

    def helpers
      ActionController::Base.helpers
    end


    def routes
      Rails.application.routes.url_helpers
    end
end
