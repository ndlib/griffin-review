require File.expand_path('../boot', __FILE__)

require 'rails/all'
require File.expand_path('../../lib/hash_ostruct', __FILE__)

if defined?(Bundler)
  # If you precompile assets before deploying to production, use this line
  Bundler.require(*Rails.groups(:assets => %w(development test)))
  # If you want your assets lazily compiled in production, use this line
  # Bundler.require(:default, :assets, Rails.env)
end

module Griffin
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Custom directories with classes and modules you want to be autoloadable.
    config.autoload_paths += %W(#{config.root}/extras)
    config.autoload_paths += Dir[Rails.root.join('lib', '{**}')]
    config.autoload_paths += Dir[Rails.root.join('app', 'models', '{**}')]
    config.autoload_paths += Dir[Rails.root.join('app', 'controllers', '{**}')]

    config.secret_key_base = "griffsseaf235151tgdffqelg1vpfa7t231"

    # Only load the plugins named here, in the order given (default is alphabetical).
    # :all can be used as a placeholder for all plugins not explicitly named.
    # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

    # Activate observers that should always be running.
    # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = 'Eastern Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = "utf-8"

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password]

    # Enable the asset pipeline
    config.assets.enabled = true

    # Version of your assets, change this if you want to expire all your assets
    config.assets.version = '1.0'

    # Additional asset paths
    config.assets.paths << Rails.root.join("app", "assets", "videos")
    config.assets.paths << Rails.root.join("app", "assets", "swf")

    config.assets.precompile << "jwplayer.js"

    # Rspec Testing configs
    config.generators do |g|
      g.test_framework :rspec,
        :fixtures => true,
        :view_specs => false,
        :helper_specs => false,
        :routing_specs => false,
        :controller_specs => true,
        :request_specs => true
      g.fixture_replacement :factory_girl, :dir => "spec/factories"
      g.form_builder :simple_form
    end

    # Sakai admin access
    ENV.update YAML.load(File.read(File.expand_path('../sakai.yml', __FILE__)))


    # Custom configs
    config.reserves_ldap_host = 'directory.nd.edu'
    config.reserves_ldap_port = 636
    config.reserves_ldap_base = 'o=University of Notre Dame,st=Indiana,c=US'
    config.reserves_ldap_service_dn = 'ndGuid=nd.edu.nddk4kq4,ou=objects,o=University of Notre Dame,st=Indiana,c=US'
    config.reserves_ldap_service_password = 'zfkpqns8'
    config.reserves_ldap_attrs = [ 'uid', 'givenname', 'sn', 'ndvanityname', 'nddepartment' ]
  end
end
