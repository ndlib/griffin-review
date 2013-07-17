source 'https://rubygems.org'

gem 'rails', '4.0'

# '3.2.13'
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
gem 'simple_form', '~> 3.0.0.rc'
gem 'nested_form'

# so that activerecord is happy with US dates
gem 'american_date'

# model validation
gem 'validates_timeliness', '~> 3.0'

# Javascript runtime
gem 'therubyracer'

gem "state_machine"

gem 'virtus'

gem "paperclip"

gem "paper_trail"

gem 'jquery-datatables-rails'


gem 'sass-rails'
gem 'coffee-rails'
gem 'uglifier', '>= 1.2.4'

# development only
group :development do
    gem 'looksee'
    gem 'rdoc'
    gem 'awesome_print'
    gem 'sextant'
end

# testing
group :test do
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
  gem 'rb-readline', '~> 0.4.2' # specified to this version becase 0.5.0 was not working with pry in ruby 1.9.3
end


# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
gem 'capistrano'

# To use debugger
# gem 'ruby-debug'
