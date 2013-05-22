class Request < ActiveRecord::Base

  attr_accessor :extent, :cms


  belongs_to :semester
  belongs_to :item

  #validates :course, :requestor_netid, :item, :presence => true


  def requestor
    "Bob Bobbers"
  end
end
