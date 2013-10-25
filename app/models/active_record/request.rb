class Request < ActiveRecord::Base

  belongs_to :semester
  belongs_to :item

  validates :semester, :course_id, :requestor_netid, :item, :presence => true

end
