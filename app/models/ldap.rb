##
# ==Introduction
#
# This is a simple interface for interacting with the excellent net-ldap gem
# 
# This interace is intended to simplify interaction with institutional directory
# services by supplying only those methods that are necessary to connect to an
# LDAP data source and query that source. It is written in such a way that it is
# hopefully easily extensible.

class Ldap

  attr_accessor :ldap_host, :ldap_port, :ldap_encryption, :ldap_username, :ldap_password
  attr_reader :ldap_object

  ##
  # ===Initializer
  #
  # The class initializer can be called with several arguments in order to
  # override instance defaults. These arguments are ldap_host, ldap_port,
  # ldap_encryption, ldap_username, and ldap_password.
  #
  def initialize args = {}
    @ldap_host = args[:ldap_host] || Rails.configuration.reserves_ldap_host
    @ldap_port = args[:ldap_port] || Rails.configuration.reserves_ldap_port
    @ldap_encryption = args[:ldap_encryption] || :simple_tls
    @ldap_username = args[:ldap_username] || Rails.configuration.reserves_ldap_service_dn
    @ldap_password = args[:ldap_password] || Rails.configuration.reserves_ldap_service_password
    @ldap_object = Net::LDAP.new
    @ldap_object.host = @ldap_host
    @ldap_object.port = @ldap_port
    @ldap_object.encryption(@ldap_encryption)
  end

  ##
  # ===Connect
  #
  # When connect() is called, either the parameters set during object initialization
  # will be used or the parameters set in the environment config file. This is a
  # wrapper for the net-ldap bind() method.
  #
  def connect
    @ldap_object.bind(
      :method   => :simple,
      :username => @ldap_username,
      :password => @ldap_password
    )
  end

  ##
  # ===Find
  #
  # The find() method is analogous to the net-ldap search() method. It takes two
  # arguments: the attribute that should be searched against, and the value used
  # for that attribute, which will act as a traditional LDAP filter. Both arguments
  # are required. If the attribute value happens to be last name ("sn"), then a list
  # of LDAP entry objects will be returned.
  #
  def find(attr,value)
    filter = Net::LDAP::Filter.eq(attr,value)
    results = []
    result = @ldap_object.search(
      :base           => Rails.configuration.reserves_ldap_base,
      :filter         => filter,
      :return_result  => true
    ) do |entry|
      results.push(entry)
    end
    unless (results.nil?)
      if (results.size >= 1)
        if (attr == 'sn')
          results
        else
          results.first
        end
      end
    end
  end
  
end
