# Add the deploy directory to the load path
$:.unshift File.join(File.dirname(__FILE__),'deploy')
require 'hesburgh/common'
require 'hesburgh/git'
require 'hesburgh/vm'
require 'hesburgh/rails'
require 'hesburgh/rails_db'
require 'hesburgh/jenkins'
require 'hesburgh/whenever'
set :application_symlinks, ['config/sakai.yml']

set :application, 'reserves'
set :repository,  "git@git.library.nd.edu:griffin"



desc "Setup for the Pre-Production environment"
task :pre_production do
  # Customize pre_production configuration
  set :rails_env, 'pre_production'
  role :app, "reservespprd.library.nd.edu"

  set :hipchat_token, "c290a842542721d6aee18a3cb900a1"
  set :hipchat_room_name, "Web and Software Engineering"
  set :hipchat_announce, false # notify users?
end


desc "Setup for the production environment"
task :production do
  # Customize production configuration
  set :rails_env, 'production'
  role :app, "wowzaprod.library.nd.edu"

  set :hipchat_token, "c290a842542721d6aee18a3cb900a1"
  set :hipchat_room_name, "Web and Software Engineering"
  set :hipchat_announce, false # notify users?
end

