#############################################################
#  Deployment Settings
#############################################################

#############################################################
#  Application
#############################################################
set :application, 'reserves'

#############################################################
#  Settings
#############################################################

default_run_options[:pty] = true
set :use_sudo, false

#############################################################
#  Source Control
#############################################################

set :scm, 'git'
# moved below because wowza is different then prod server for now.
# set :scm_command,   '/usr/bin/git'
set :repository, "git@git.library.nd.edu:griffin"


#############################################################
#  Environments
#############################################################

desc "Setup for the Pre-Production environment"
task :pre_production do
  ssh_options[:keys] = %w(/shared/jenkins/.ssh/id_rsa)
  ssh_options[:paranoid] = false

  set :rails_env, 'pre_production'
  set :deploy_to, "/home/app/#{application}"
  set :ruby_bin,  '/opt/ruby/current/bin'
  set :scm_command,   '/usr/bin/git'

  set :ruby,      File.join(ruby_bin, 'ruby')
  set :bundler,   File.join(ruby_bin, 'bundle')
  set :rake,      File.join(ruby_bin, 'rake')
  set :user,      'app'
  set :domain,    'reservespprd.library.nd.edu'
  set :site_url,  'reservespprd.library.nd.edu'
  set :branch,    'v5'

  server "#{user}@#{domain}", :app, :web, :db, :primary => true
end

desc "Setup for the Production environment"
task :production do
  ssh_options[:keys] = %w(/shared/jenkins/.ssh/id_rsa)
  ssh_options[:paranoid] = false

  set :rails_env, 'production'
  set :deploy_to, "/home/app/#{application}"
  set :ruby_bin,  '/opt/ruby/current/bin'
  set :scm_command,   '/usr/bin/git'

  set :ruby,      File.join(ruby_bin, 'ruby')
  set :bundler,   File.join(ruby_bin, 'bundle')
  set :rake,      File.join(ruby_bin, 'rake')
  set :user,      'app'
  set :domain,    'wowzaprod.library.nd.edu'
  set :site_url,  'wowzaprod.library.nd.edu'
  set :branch,    'master'
  set :git_shallow_clone, 1

  server "#{user}@#{domain}", :app, :web, :db, :primary => true
end

#############################################################
#  Passenger
#############################################################

desc "Restart Application"
task :restart_passenger do
  run "touch #{current_path}/tmp/restart.txt"
end

#############################################################
#  Deploy
#############################################################

namespace :deploy do
  desc "Start application in Passenger"
  task :start, :roles => :app do
    restart_passenger
  end

  desc "Restart application in Passenger"
  task :restart, :roles => :app do
    restart_passenger
  end

  task :stop, :roles => :app do
    # Do nothing.
  end

  desc "Symlink shared configs and folders on each release."
  task :symlink_shared, :roles => :app do
    run "ln -nfs #{shared_path}/log #{release_path}/log"
    run "ln -nfs #{shared_path}/bundle/config #{release_path}/.bundle/config"
    run "ln -nfs #{shared_path}/vendor/bundle #{release_path}/vendor/bundle"
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config"
    run "ln -nfs #{shared_path}/config/sakai.yml #{release_path}/config"
    run "ln -nfs #{shared_path}/data/movs #{release_path}/uploads/"
    run "ln -nfs #{shared_path}/data/reserves_files #{release_path}/uploads/pdfs"
    run "ln -nfs #{shared_path}/data/old_files #{release_path}/uploads/"
  end

  desc "Spool up Passenger spawner to keep user experience speedy"
  task :kickstart, :roles => :app do
    run "curl -I http://#{site_url}"
  end

  desc "Run the migrate rake task"
  task :migrate, :roles => :app do
    run "cd #{release_path} && #{bundler} exec #{rake} RAILS_ENV=#{rails_env} db:migrate --trace"
  end

end

namespace :bundle do
  desc "Install gems in Gemfile"
  task :install, :roles => :app do
    run "#{bundler} install --gemfile='#{release_path}/Gemfile'"
  end
end

after 'deploy:update_code', 'deploy:symlink_shared', 'bundle:install', 'deploy:migrate'
after 'deploy', 'deploy:cleanup', 'deploy:restart', 'deploy:kickstart'


# Define any addional tasks or callbacks here
require 'lib/deploy/whenever'

