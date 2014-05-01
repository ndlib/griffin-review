require 'hipchat'

# Set the name of the application.  This is used to determine directory paths and domains
set :application, 'reserves'
set :repository,  "git@git.library.nd.edu:griffin"

#############################################################
#  Application settings
#############################################################

# Defaults are set in lib/hesburgh_infrastructure/capistrano/common.rb

# Repository defaults to "git@git.library.nd.edu:#{application}"
# set :repository, "git@git.library.nd.edu:myrepository"

# Define symlinks for files or directories that need to persist between deploys.
# /log, /vendor/bundle, and /config/database.yml are automatically symlinked
# set :application_symlinks, ["/path/to/file"]

#############################################################
#  Environment settings
#############################################################

# Defaults are set in lib/hesburgh_infrastructure/capistrano/environments.rb

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
end

#############################################################
#  Additional callbacks and tasks
#############################################################

# Define any addional tasks or callbacks here
