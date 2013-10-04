class CourseMock < Course
  
  def semester
    Semester.semester_for_code(Semester.current.first.code)
  end


  def self.mock_data
    JSON.parse( IO.read(File.join(Rails.root, 'config', 'course_mock.json')) )
  end

end
