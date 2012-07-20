source 'http://rubygems.org'

gem 'rails', '3.1.1'

# Bundle edge Rails instead:
# gem 'rails',     :git => 'git://github.com/rails/rails.git'

# ILS compendium gem
gem 'compendium', :git => 'ssh://git@git.library.nd.edu/compendium'

# db backends
gem 'mysql2', "~> 0.3.11"

# authentication
gem 'rubycas-client'
gem 'devise'
gem 'devise_cas_authenticatable'

# authorization
gem 'cancan'

gem 'json'

# LDAP lookups
gem 'net-ldap'

# form generation
gem 'simple_form'

# Javascript runtime
gem 'therubyracer'

# REST queries
gem 'rest-client', "~> 1.6.7"

# development only
group :development do
    # specific versions of boson and irbtools for ruby 1.8.7
    gem 'boson', "0.3.4"
    gem 'irbtools', "1.0.6", :require => 'irbtools/configure'
    gem 'looksee'
    gem 'rspec-rails'
    gem 'rdoc'
    gem 'awesome_print'
end

# testing
group :test do
	gem 'rspec'
	gem 'rspec-core'
	gem 'rspec-expectations'
	gem 'rspec-mocks'
    gem 'rspec-rails'
	gem 'guard-rspec'
	gem 'guard-coffeescript'
	gem 'guard-shell'
	gem 'guard-rails'
	gem 'growl'
	gem 'growl-rspec'
	gem 'rb-fsevent'
    gem 'database_cleaner'
	gem 'webrat'
	gem 'factory_girl', "~> 2.6.0"
	gem 'factory_girl_rails', "~> 1.7.0"
	gem "spork", "~> 0.9.0"
	gem "guard-spork", '<= 0.5.1'
end

gem 'jquery-rails', '1.0.19'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.1.4'
  gem 'coffee-rails', '~> 3.1.1'
  gem 'uglifier', '>= 1.0.3'
end


# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
gem 'capistrano'

# To use debugger
# gem 'ruby-debug'
