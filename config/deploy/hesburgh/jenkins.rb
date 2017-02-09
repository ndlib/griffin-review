Capistrano::Configuration.instance(:must_exist).load do

  ssh_options[:paranoid] = false
  ssh_options[:keys] = %w(/opt/jenkins/.ssh/id_rsa)

end
