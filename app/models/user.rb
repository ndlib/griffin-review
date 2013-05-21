class User < ActiveRecord::Base

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :cas_authenticatable, :trackable

  before_validation :fetch_attributes_from_ldap, :on => :create
  before_validation :fetch_attributes_from_ldap, :on => :update

  has_many :assignments, :dependent => :destroy
  has_many :roles, :through => :assignments
  has_many :requests
  has_many :video_workflows, :foreign_key => 'workflow_state_change_user'

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :username, :last_name, :first_name, :role_ids, :display_name, :roles

  validates :username, :email, :uniqueness => true
  validates_presence_of :email, :username, :first_name, :last_name, :display_name
  validate :must_exist_in_ldap

  scope :non_administrator, :include => :roles, :conditions => ['roles.name != ?', 'Administrator']

  def name
    "#{first_name} #{last_name}"
  end

  # roles
  def has_role?(role_sym)
    roles.any? { |r| r.name.split.join.to_s.underscore.to_sym == role_sym }
  end

  def requester_display
    "#{self.display_name} (#{self.username})"
  end

  def self.get_affiliation(ldap_result)
    # This is engineered to get the most important affiliation in
    # LDAP for authorization purposes. The order of preference, if someone
    # falls into multiple categories is: staff -> faculty -> graduate student
    # -> undergrad

    total_affiliation = []
    ldap_result[:edupersonalaffiliation].each {|a| total_affiliation.push(a.downcase)}
    ldap_result[:ndaffiliation].each {|a| total_affiliation.push(a.downcase)}
    ldap_result[:edupersonprimaryaffiliation].each {|a| total_affiliation.push(a.downcase)}
    ldap_result[:ndprimaryaffiliation].each {|a| total_affiliation.push(a.downcase)}
    total_affiliation.flatten!
    secondary_affiliation = []
    ldap_result[:ndtitle].each {|s| secondary_affiliation.push(s.downcase)}
    ldap_result[:title].each {|s| secondary_affiliation.push(s.downcase)}
    ldap_result[:ndlevel].each {|s| secondary_affiliation.push(s.downcase)}
    secondary_affiliation.flatten!
    final_affiliation = ''
    temp_affiliation = ''
    case
    when total_affiliation.include?('student')
      temp_affiliation = 'student'
    when total_affiliation.include?('staff')
      final_affiliation = 'staff'
    when total_affiliation.include?('faculty')
      final_affiliation = 'faculty'
    else
      final_affiliation = 'unknown'
    end

    case temp_affiliation
    when 'student'
      secondary_array = secondary_affiliation.grep /grad/i
      if secondary_array.empty? == false
        final_affiliation = 'grad'
      elsif secondary_affiliation.include?('senior')
        final_affiliation = 'undergrad'
      elsif secondary_affiliation.include?('junior')
        final_affiliation = 'undergrad'
      elsif secondary_affiliation.include?('sophomore')
        final_affiliation = 'undergrad'
      elsif secondary_affiliation.include?('freshman')
        final_affiliation = 'undergrad'
      end
    end

    final_affiliation
  end

  # ldap
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
                         'displayname',
                         'edupersonaffiliation',
                         'ndaffiliation',
                         'edupersonprimaryaffiliation',
                         'ndprimaryaffiliation',
                         'ndtitle',
                         'ndlevel',
                         'title'
                        ],
      :filter        => Net::LDAP::Filter.eq( 'uid', username ),
      :return_result => true
    )
    results.first
  end

  private

  def must_exist_in_ldap
    if Rails.configuration.ldap_lookup_flag
      if !User.ldap_lookup(username)
        errors.add(:username, "not valid username")
      end
    end
  end

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
    if Rails.configuration.ldap_lookup_flag
      attributes = User.ldap_lookup(username)
      fn = attributes[:givenname].first
      sn = attributes[:sn].first
      nickname = attributes[:ndvanityname].first
      self.first_name, self.last_name = preferred_name_from_nickname(fn, sn, nickname)
      self.email = attributes[:mail].first
      self.display_name = attributes[:displayname].first

      # affiliation setting for authorization
      primary_association = User.get_affiliation(attributes)
      case primary_association
      when 'faculty'
        faculty_role = Role.where(:name => 'Faculty').first_or_create(:description => 'Teaching and research faculty of the university')
        self.roles.push(faculty_role) unless self.roles.include?(faculty_role)
      when 'grad'
        grad_role = Role.where(:name => 'Graduate Student').first_or_create(:description => 'Graduate student enrolled in the university')
        self.roles.push(grad_role) unless self.roles.include?(grad_role)
      when 'staff'
        staff_role = Role.where(:name => 'Staff').first_or_create(:description => 'Full or part time staff of the university')
        self.roles.push(staff_role) unless self.roles.include?(staff_role)
      when 'undergrad'
        undergrad_role = Role.where(:name => 'Undergraduate Student').first_or_create(:description => 'Undergraduate student enrolled in the university')
        self.roles.push(undergrad_role) unless self.roles.include?(undergrad_role)
      end
    end
  end

end
