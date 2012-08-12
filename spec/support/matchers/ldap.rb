require 'net/ldap'

RSpec::Matchers.define :be_a_valid_connection do
  match do |actual|
    actual.ldap_object.get_operation_result.message.eql?('Success')    
  end

  failure_message_for_should do |actual|
    "was not a valid connection"
  end

  failure_message_for_should_not do |actual|
    "was a valid connection but should have failed"
  end

  description do
    "is a valid ldap connection"
  end
end
