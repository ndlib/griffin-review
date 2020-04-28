source 'https://rubygems.org'

group :application do
  gem 'rails', '~> 4.2.11'

  # '3.2.13'
  # Bundle edge Rails instead:
  # gem 'rails',     :git => 'git://github.com/rails/rails.git'

  # ILS compendium gem
  # gem 'compendium', :git => 'ssh://git@git.library.nd.edu/compendium'

  gem 'hesburgh_assets', :github => 'ndlib/hesburgh_assets'

  gem 'addressable'
  gem 'bigdecimal', '1.3.2'
  # db backends
  gem 'mysql2', '0.5.2'

  # SOAP interface
  gem 'savon', '2.2.0'

  #memcache
  gem 'dalli'

  # authentication
  gem 'devise', "~> 4.7.1"
  gem 'omniauth-oktaoauth'

  gem 'simple_token_authentication', '1.17.0'


  gem 'breach-mitigation-rails'

  # exception logging
  # gem 'airbrake'
  gem "sentry-raven", "~> 2.7"
  gem 'exception_notification', "~> 4.0.0"

  gem 'acts-as-taggable-on'

  # workflow functionality
  gem 'workflow', '0.8.1'

  # external service interaction
  gem 'faraday', '0.15.4'
  gem 'faraday_middleware', '0.13.1'
  gem 'typhoeus'
  gem 'excon'


  gem 'json'

  # LDAP lookups
  gem 'net-ldap', '~> 0.16.0'

  # form generation
  gem 'simple_form', '~> 3.0.0'

  # so that activerecord is happy with US dates
  gem 'american_date'

  # model validation
  gem 'validates_timeliness', '~> 3.0'

  # Javascript runtime
  gem 'therubyracer'

  gem "state_machine"

  gem 'virtus'

  gem "paperclip", '~> 4.2.2'

  # gem 'paper_trail', git: 'git://github.com/airblade/paper_trail.git'
  # gem "paper_trail"

  gem 'jquery-datatables-rails'
  gem 'rails-jquery-autocomplete'

  gem 'sass-rails'
  gem 'coffee-rails'
  gem 'uglifier', '>= 1.2.4'

  gem 'newrelic_rpm'

  gem 'user_agent_parser'

  gem 'rb-readline'

  gem 'draper'
  gem 'sort_alphabetical'

  gem 'xml-simple'
end

gem "whenever", :require => false

# Deploy with Capistrano
gem 'capistrano'

# development only
group :development do
  gem 'rdoc'
  gem 'awesome_print'
  gem 'bullet'
  gem 'quiet_assets'
end

# testing
group :test do
  gem 'json_spec'
  gem 'capybara'
  gem 'launchy', '~> 2.1.0'
  gem 'faker'
  gem 'selenium-webdriver'

	gem 'rb-fsevent'
  gem 'database_cleaner'
  gem 'factory_bot'
  gem 'factory_bot_rails'
	gem 'spork-rails', :github => 'sporkrb/spork-rails'

  gem 'guard-rspec'
  gem 'guard-livereload'
  gem 'guard-coffeescript'
  gem 'guard-rails'
  gem 'guard-bundler'
  gem 'guard-spork'
  gem 'guard-shell'

  gem 'vcr'
  gem 'webmock'
end


group :development, :test do
  gem 'rspec-rails'
  gem 'pry-rails' # Debugger replacements.  Use "binding.pry" where you would use "debugger"

  gem 'growl'
  #gem 'growl-rspec'
end

gem 'rack-mini-profiler', '~> 0.10.1'

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# Use unicorn as the web server
# gem 'unicorn'

# To use debugger
# gem 'ruby-debug'
