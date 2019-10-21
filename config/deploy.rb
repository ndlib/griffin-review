# Add the deploy directory to the load path
$:.unshift File.join(File.dirname(__FILE__),'deploy')
require 'hesburgh/common'
require 'hesburgh/git'
require 'hesburgh/vm'
require 'hesburgh/rails'
require 'hesburgh/rails_db'
require 'hesburgh/jenkins'
require 'hesburgh/prompt_branch'
require 'hesburgh/whenever'

set :application_symlinks, [
  'config/secrets.yml',
  { 'data/movs' => 'uploads/movs' },
  { 'data/reserves_files' => 'uploads/pdfs' },
  { 'data/old_files' => 'uploads/old_files' }
]


set :application, 'reserves'
set :repository,  "https://github.com/ndlib/griffin.git"

set :user, 'app'

desc "Setup for the prep environment"
task :prep do
  # Customize prep configuration
  set :rails_env, 'prep'
  role :app, "reserves-prep.lc.nd.edu"

  set :hipchat_token, "c290a842542721d6aee18a3cb900a1"
  set :hipchat_room_name, "Web and Software Engineering"
  set :hipchat_announce, false # notify users?
end


desc "Setup for the production environment"
task :production do
  # Customize production configuration
  set :rails_env, 'production'
  role :app, "reserves-prod.lc.nd.edu"

  set :hipchat_token, "c290a842542721d6aee18a3cb900a1"
  set :hipchat_room_name, "Web and Software Engineering"
  set :hipchat_announce, false # notify users?
end
