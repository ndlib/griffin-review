require 'state_machine'
require 'state_machine/version'

if StateMachine::VERSION.to_f <= 1.2
  puts '~' * 50
  puts 'TheComments'
  puts '~' * 50
  puts 'WARNING!'
  puts 'StateMachine patch for Rails4 will be applied'
  puts
  puts '> private method *around_validation* from StateMachine::Integrations::ActiveModel will be public'
  puts
  puts 'https://github.com/pluginaweek/state_machine/issues/295'
  puts 'https://github.com/pluginaweek/state_machine/issues/251'
  puts '~' * 50

  module StateMachine::Integrations::ActiveModel
     public :around_validation
  end

end
