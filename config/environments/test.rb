Griffin::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # The test environment is used exclusively to run your application's
  # test suite.  You never need to work with it otherwise.  Remember that
  # your test database is "scratch space" for the test suite and is wiped
  # and recreated between test runs.  Don't rely on the data there!
  config.cache_classes = true

  # Configure static asset server for tests with Cache-Control for performance
  config.serve_static_files= true
  config.static_cache_control = "public, max-age=3600"

  # Log level
  config.log_level = :debug

  config.eager_load = false

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Raise exceptions instead of rendering exception templates
  config.action_dispatch.show_exceptions = false

  # Disable request forgery protection in test environment
  config.action_controller.allow_forgery_protection    = false

  # Tell Action Mailer not to deliver emails to the real world.
  # The :test delivery method accumulates sent emails in the
  # ActionMailer::Base.deliveries array.
  config.action_mailer.delivery_method = :test

  # Use SQL instead of Active Record's schema dumper when creating the test database.
  # This is necessary if your schema can't be completely dumped by the schema dumper,
  # like if you have constraints or database-specific column types
  # config.active_record.schema_format = :sql

  # Print deprecation notices to the stderr
  config.active_support.deprecation = :stderr

  # Action mailer settings
  config.action_mailer.delivery_method = :test
  config.action_mailer.default_url_options = { :host => "localhost" }

  # Custom configuration
  config.api_lookup_flag                 = false
  config.reserves_upload_path             = '/shared/data/reserves_files'
  config.rspec_uid                        = 'rfox2'
  config.rspec_cn                         = 'Robert Fox'
  config.rspec_last_name                  = "Fox"

  config.path_to_old_files                = File.join(Rails.root, 'uploads', 'old_files')

  config.sakai_domain                     = "https://nd-test.rsmart.com"

  # ND Calendar
  config.nd_calendar                    = 'http://calendar.nd.edu'
  config.nd_calendar_path               = '/webcache/v1.0/xmlDays/356/list-xml/%28catuid%3D%272c936ab1-29f6bcb3-012a-15374ec0-00000e64%27%29.xml'

end
