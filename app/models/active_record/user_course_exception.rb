class UserCourseException < ActiveRecord::Base

  validates :section_group_id, :netid, :role, :term, presence: true
  validates :role, inclusion: { in: %w(enrollment instructor) }


  def self.create_enrollment_exception!(course_id, term, netid)
    ucx = self.new(section_group_id: course_id, term: term, netid: netid, role: 'enrollment')
    ucx.save!
    ucx
  end


  def self.create_instructor_exception!(course_id, term, netid)
    ucx = self.new(section_group_id: course_id, term: term, netid: netid, role: 'instructor')
    ucx.save!
    ucx
  end


  def self.user_exceptions(netid, term)
    where(netid: netid).
    where(term: term)
  end


  def self.user_course_exception(course_id, netid, term)
    where(section_group_id: course_id).
    where(term: term).
    where(netid: netid).
    first
  end


  def self.course_instructor_exceptions(course_id, term)
    where(section_group_id: course_id).
    where(term: term).
    where(role: 'instructor')
  end


  def self.course_enrollment_exceptions(course_id, term)
    where(section_group_id: course_id).
    where(term: term).
    where(role: 'enrollment')
  end



  def enrollment?
    role == "enrollment"
  end


  def instructor?
    role == "instructor"
  end

end
