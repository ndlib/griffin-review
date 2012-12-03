class Role < ActiveRecord::Base

  has_many :assignments, :dependent => :destroy
  has_many :users, :through => :assignments

  validates :name, :uniqueness => true
  validates_presence_of :name, :message => 'Role name is required'

end
