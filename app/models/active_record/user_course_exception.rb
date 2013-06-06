class UserCourseException < ActiveRecord::Base

  validates :netid, :role, :semester_code, presence: true
  validates :role, inclusion: { in: %w(student instructor) }


  def self.create_student_exception!(section_id, semester_code, netid)
    self.new(section_id: section_id, semester_code: semester_code, netid: netid, role: 'student').save!
  end


  def self.create_instructor_exception!(section_id, semester_code, netid)
    self.new(section_id: section_id, semester_code: semester_code, netid: netid, role: 'instructor').save!
  end


  def self.user_course_exceptions(netid, semester_code)
    where(netid: netid).
    where(semester_code: semester_code)
  end


  def student?
    role == "student"
  end


  def instructor?
    role == "instructor"
  end

end
