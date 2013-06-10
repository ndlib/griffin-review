class UserCourseException < ActiveRecord::Base

  validates :section_group_id, :netid, :role, :term, presence: true
  validates :role, inclusion: { in: %w(enrollment instructor) }


  def self.create_enrollment_exception!(section_group_id, term, netid)
    self.new(section_group_id: section_group_id, term: term, netid: netid, role: 'enrollment').save!
  end


  def self.create_instructor_exception!(section_group_id, term, netid)
    self.new(section_group_id: section_group_id, term: term, netid: netid, role: 'instructor').save!
  end


  def self.user_course_exceptions(netid, term)
    where(netid: netid).
    where(term: term)
  end


  def self.course_instructor_exceptions(section_group_id, term)
    where(section_group_id: section_group_id).
    where(term: term).
    where(role: 'instructor')
  end


  def self.course_enrollment_exceptions(section_group_id, term)
    where(section_group_id: section_group_id).
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
