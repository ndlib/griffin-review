class User < ActiveRecord::Base

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :cas_authenticatable, :trackable

  before_save :fetch_attributes_from_ldap, :on => :create

  has_many :assignments
  has_many :roles, :through => :assignments

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :username

  # roles
  def has_role?(role_sym)
    roles.any? { |r| r.name.underscore.to_sym == role_sym }
  end

  def self.ldap_lookup(username)
    return nil if username.blank?
    ldap = Net::LDAP.new :host => Rails.configuration.reserves_ldap_host,
                         :port => Rails.configuration.reserves_ldap_port,
                         :auth => { :method   => :simple,
                                    :username => Rails.configuration.reserves_ldap_service_dn,
                                    :password => Rails.configuration.reserves_ldap_service_password
                                  },
                         :encryption => :simple_tls
    results = ldap.search(
      :base          => Rails.configuration.reserves_ldap_base,
      :attributes    => [
                         'uid',
                         'givenname',
                         'sn',
                         'ndvanityname',
                         'mail',
                         'displayname'
                        ],
      :filter        => Net::LDAP::Filter.eq( 'uid', username ),
      :return_result => true
    )
    results.first
  end

  private

  def preferred_name_from_nickname(first_name, last_name, nickname)
    if nickname
      nickname_array = nickname.split(' ')
      if nickname_array.count == 1
        # If there is only one word in the nickname assume it is the first name
        return [nickname, last_name]
      else
        # If there is more than one word in the nickname assume it the full name
        return [nickname_array[0], (nickname_array - [nickname_array[0]]).join(' ')]
      end
    end
    [first_name, last_name]
  end

  def fetch_attributes_from_ldap
    attributes = User.ldap_lookup(username)
    fn = attributes[:givenname].first
    sn = attributes[:sn].first
    nickname = attributes[:ndvanityname].first
    self.first_name, self.last_name = preferred_name_from_nickname(fn, sn, nickname)
    self.email = attributes[:mail].first
    self.display_name = attributes[:displayname].first
  end

end
