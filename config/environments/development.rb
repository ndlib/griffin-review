Griffin::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # Disable Rails's static asset server (Apache or nginx will already do this)
  config.serve_static_assets = false

  # Generate digests for assets URLs
  config.assets.digest = false

  # Defaults to Rails.root.join("public/assets")
  # config.assets.manifest = Rails.root.join("public/assets")

  # In the development environment your application's code is reloaded on
  # every request.  This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  config.eager_load = false

  # Log level
  config.log_level = :debug

  # Raise exception on mass assignment protection for Active Record models
  # config.active_record.mass_assignment_sanitizer = :strict


  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
  #config.force_ssl = true

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin

  # Do not compress assets
  config.assets.compress = false

  # Expands the lines which load the assets
  config.assets.debug = true

  # Action mailer settings
  config.action_mailer.delivery_method = :test
  config.action_mailer.default_url_options = { :host => "localhost" }

  # Custom configuration
  config.ldap_lookup_flag = true
  config.reserves_upload_path = '/shared/data/reserves_files'
  config.reserves_cas_base = 'https://cas.library.nd.edu/cas'

  config.api_url = "https://apipprd.library.nd.edu/"
  config.api_token = "SCSGYmwqLqSyBTmxCQgM"


  config.path_to_old_files = File.join(Rails.root, 'uploads', 'old_files')

end
