require 'hesburgh/symlink_shared'

Capistrano::Configuration.instance(:must_exist).load do

  set :recipe_symlinks, fetch(:recipe_symlinks) + ['/log', '/vendor/bundle', '/config/database.yml']

  _cset(:ruby) {fetch(:ruby_bin) ? File.join(ruby_bin, 'ruby') : 'ruby'}
  _cset(:bundler) {fetch(:ruby_bin) ? File.join(ruby_bin, 'bundle') : 'bundle'}
  _cset(:binstubs_path)  {File.join(shared_path, 'vendor/bundle/bin')}
  unset(:rake)
  _cset(:rake) {"cd #{release_path}; #{fetch(:bundler)} exec #{File.join(fetch(:binstubs_path), 'rake')} RAILS_ENV=#{fetch(:rails_env)}"}

  after 'deploy:update_code',
    'bundle:install',
    'assets:precompile'

  namespace :deploy do
    task :start do ; end
    task :stop do ; end
    task :restart, :roles => :app, :except => { :no_release => true } do
      run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
    end
  end

  namespace :assets do
    desc "Precompile assets"
    task :precompile do
      run "#{fetch(:rake)} assets:precompile"
    end
  end

  namespace :bundle do
    desc "Install gems in Gemfile"
    task :install, :roles => :app do
      run "#{fetch(:bundler)} install --binstubs='#{fetch(:binstubs_path)}' --shebang '#{fetch(:ruby)}' --gemfile='#{File.join(release_path, 'Gemfile')}' --without development test --deployment"
    end
  end
end
