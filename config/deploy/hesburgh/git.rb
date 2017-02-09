Capistrano::Configuration.instance(:must_exist).load do

  unset(:repository)
  _cset(:repository) { "https://github.com/ndlib/griffin.git" }

  set :scm, :git
  set :deploy_via, :remote_cache

  default_run_options[:pty]     = true # needed for git password prompts

end
