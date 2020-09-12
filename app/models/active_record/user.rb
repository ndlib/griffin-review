class User < ActiveRecord::Base
  acts_as_token_authenticatable

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :omniauthable, omniauth_providers: [:oktaoauth]

  before_validation :map_user

  has_many :assignments, :dependent => :destroy
  has_many :roles, :through => :assignments
  has_many :requests
  has_many :video_workflows, :foreign_key => 'workflow_state_change_user'

  # Setup accessible (or protected) attributes for your model
#  attr_accessible :email, :username, :last_name, :first_name, :role_ids, :display_name, :roles

  validates :username, :email, :uniqueness => true
  validates_presence_of :email, :username, :first_name, :last_name, :display_name
  validate :must_exist_in_api

  scope :username, lambda { | username |  where(username: username) }

  store :admin_preferences, accessors: [ :libraries, :types, :reserve_type, :instructor_range_begin, :instructor_range_end ]

  def name
    "#{first_name} #{last_name}"
  end


  def username
    self[:username].to_s.downcase.strip
  end

  # roles
  def has_role?(role_sym)
    roles.any? { |r| r.name.split.join.to_s.underscore.to_sym == role_sym }
  end


  def requester_display
    "#{self.display_name} (#{self.username})"
  end


  def admin?
    self.admin || ['rfox2', 'jhartzle', 'fboze', 'dwolfe2', 'mkirkpa2'].include?(self.username)
  end


  def wse_admin?
    ['rfox2', 'jhartzle', 'dwolfe2', 'mkirkpa2'].include?(self.username)
  end


  def set_admin!
    self.admin = true
    self.save!
  end


  def revoke_admin!
    self.admin = false
    self.save!
  end

  def self.generate_imported_user
    User.new(display_name: 'Imported')
  end

  private

  def must_exist_in_api
    if Rails.configuration.api_lookup_flag
      if API::Person.find(username)["first_name"].nil?
        errors.add(:username, " not valid username")
      end
    end
  end

  def map_user
    if Rails.configuration.api_lookup_flag
      MapUserToApi.call(self)
    end
  end

  class APIException < Exception
  end
end