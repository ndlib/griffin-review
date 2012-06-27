class Student < OpenReserves
  self.table_name = 'users'
  self.primary_key = 'userid_key'

  validates :userid, :presence => true
  validates :role, :presence => true, :inclusion => { :in => %w(Student) }

  default_scope where(:role => 'Student')

  scope :currently_enrolled, lambda { |semester|
    select('DISTINCT userid').where("course_id like ? and userid regexp '^[a-zA-Z]+$'", semester + '%')
  }

end
