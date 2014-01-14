# Base Capistrano recipe for deploying applications running under passenger

Capistrano::Configuration.instance(:must_exist).load do

  namespace :whenever do

    desc "Builds the whenever cron file on the server"
    task :update_crontab, :roles => :app do
      puts "update crontab"
      # this can be removed when we update to the infatructure gem.
      _cset :binstubs_path,  File.join(shared_path, 'vendor/bundle/ruby/2.0.0/bin')
      _cset(:whenever_command)      { "whenever" }
      _cset(:whenever_identifier)   { fetch :application }
      _cset(:whenever_environment)  { fetch :rails_env, "production" }
      _cset(:whenever_variables)    { "environment=#{fetch :whenever_environment}" }

      run "cd #{release_path}; #{bundler} exec #{File.join(binstubs_path, 'whenever')} --update-crontab #{fetch :whenever_identifier} --set #{fetch :whenever_variables}"
    end

  end

  after 'deploy:cleanup', 'whenever:update_crontab'
end
