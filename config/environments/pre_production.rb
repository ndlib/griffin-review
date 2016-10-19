Griffin::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # Code is not reloaded between requests
  config.cache_classes = true

  # Full error reports are disabled and caching is turned on
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = true
  config.cache_store = :mem_cache_store, '127.0.0.1:11211', { compress: true }


  config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect'

  # Error routing
  config.exceptions_app = self.routes

  # Disable Rails's static asset server (Apache or nginx will already do this)
  config.serve_static_files= false

  # Compress JavaScripts and CSS
  config.assets.compress = true

  config.eager_load = true

  # Don't fallback to assets pipeline if a precompiled asset is missed
  config.assets.compile = true

  # Generate digests for assets URLs
  config.assets.digest = true

  # Defaults to Rails.root.join("public/assets")
  # config.assets.manifest = YOUR_PATH

  # Specifies the header that your server uses for sending files
  # config.action_dispatch.x_sendfile_header = "X-Sendfile" # for apache
  # config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect' # for nginx

  # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
  # config.force_ssl = true

  # See everything in the log (default is :info)
  config.log_level = :debug

  # Use a different logger for distributed setups
  # config.logger = SyslogLogger.new

  # Use a different cache store in production
  # config.cache_store = :mem_cache_store

  # Enable serving of images, stylesheets, and JavaScripts from an asset server
  # config.action_controller.asset_host = "http://assets.example.com"

  # Precompile additional assets (application.js, application.css, and all non-JS/CSS are already added)
  # config.assets.precompile += %w( search.js )
  config.assets.precompile += %w( admin.css jquery_ujs.js jquery_nested_form.js autocomplete-rails.js admin/jquery-ui-1.8.22.cusom.min.js dataTables/jquery.dataTables.js dataTables/jquery.dataTables.typeDetection.numbersHtml.js dataTables/jquery.dataTables.sorting.numbersHtml.js underscore.js admin/video_workflow.js admin.js external.css external/superfish.js external/jquery-ui-1.8.22.custom.min.js external/request.js external.js jquery.js bootstrap.js bootstrap-dropdown.js bootstrap.min.js bootstrap-responsive.css bootstrap-responsive.min.css bootstrap.css bootstrap.min.css bootstrap_and_overrides.css bootstrap_external.css forms.css jquery-ui-1.8.22.custom.css scaffolds.css admin/group.css admin/item.css admin/role.css admin/technical_metadata.css admin/user.css admin/video.css admin/video_queue.css dataTables/jquery.dataTables.bootstrap.css dataTables/jquery.dataTables.css external/request.css )

  # Disable delivery errors, bad email addresses will be ignored
  # config.action_mailer.raise_delivery_errors = false

  # Enable threaded mode
  # config.threadsafe!

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation can not be found)
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners
  config.active_support.deprecation = :notify

  # Action mailer settings
  config.action_mailer.delivery_method = :sendmail
  config.action_mailer.default_url_options = { :host => "reservespprd.library.nd.edu" }

  # Custom configuration
  config.ldap_lookup_flag               = true
  config.reserves_upload_path           = '/shared/reserves_pprd/data/files'
  config.reserves_cas_base              = 'https://login.nd.edu/cas'
  config.reserves_cas_validate          = 'https://login.nd.edu/cas/serviceValidate'
  config.reserves_cas_logout            = 'https://login.nd.edu/cas/logout'

  config.api_url                        = "https://apipprd.library.nd.edu"
  config.api_token                      = "SCSGYmwqLqSyBTmxCQgM"

  config.path_to_old_files              = File.join(Rails.root, 'uploads', 'old_files')
end
