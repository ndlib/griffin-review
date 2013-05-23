class Request < ActiveRecord::Base

  belongs_to :semester
  belongs_to :item

  validates :course_id, :requestor_netid, :item, :presence => true

  def requestor
    "Bob Bobbers"
  end
end
