class UserCourseException < ActiveRecord::Base

  validates :netid, :role, presence: true
  validates :role, inclusion: { in: %w(student, instructor) }
end
