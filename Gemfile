source 'http://rubygems.org'

gem 'rails', '3.2.13'

# Bundle edge Rails instead:
# gem 'rails',     :git => 'git://github.com/rails/rails.git'

# ILS compendium gem
gem 'compendium', :git => 'ssh://git@git.library.nd.edu/compendium'

gem 'hesburgh_assets', :git => 'git@git.library.nd.edu:assets'

gem 'american_date'

# db backends
gem 'mysql2', "~> 0.3.11"

# authentication
gem 'rubycas-client'
gem 'devise'
gem 'devise_cas_authenticatable'

# exception logging
gem 'airbrake'

gem 'acts-as-taggable-on'

# workflow functionality
gem 'workflow', '0.8.1'

# authorization
gem 'cancan'

gem 'json'

# LDAP lookups
gem 'net-ldap'

# form generation
gem 'simple_form'
gem 'nested_form'

# model validation
gem 'validates_timeliness', '~> 3.0'

# Javascript runtime
gem 'therubyracer'

# REST queries
gem 'rest-client', "~> 1.6.7"

gem "state_machine"

gem 'virtus'

# development only
group :development do
    gem 'pry-rails'
    gem 'looksee'
    gem 'rspec-rails'
    gem 'rdoc'
    gem 'awesome_print'
    gem 'sextant'
end

# testing
group :test do
	gem 'rspec', '~> 2.11.0'
	gem 'rspec-core', '~> 2.11.0'
	gem 'rspec-expectations', '~> 2.11.0'
	gem 'rspec-mocks', '~> 2.11.0'
    gem 'rspec-rails'
    gem 'json_spec'
    gem 'capybara'
    gem 'launchy', '~> 2.1.0'
    gem 'faker'
    gem 'selenium-webdriver'

	gem 'growl'
	gem 'growl-rspec'
	gem 'rb-fsevent'
    gem 'database_cleaner'
	gem 'factory_girl', "~> 2.6.0"
	gem 'factory_girl_rails', "~> 1.7.0"
	gem "spork", "~> 0.9.0"

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

gem 'jquery-rails', '2.1.4'
gem 'jquery-datatables-rails'
gem 'rails-backbone'


group :development, :test do
  gem 'pry-rails' # Debugger replacements.  Use "binding.pry" where you would use "debugger"
  gem 'rb-readline', '~> 0.4.2' # specified to this version becase 0.5.0 was not working with pry in ruby 1.9.3
end


# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.5'
  gem 'coffee-rails', '~> 3.2.2'
  gem 'uglifier', '>= 1.2.4'
end


# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
gem 'capistrano'

# To use debugger
# gem 'ruby-debug'
