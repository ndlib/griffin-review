class CourseMock < Course

  def semester
    Semester.current.first
  end


  def self.mock_data
    JSON.parse( IO.read(File.join(Rails.root, 'config', 'course_mock.json')) )
  end


  def self.missing_data
    JSON.parse( IO.read(File.join(Rails.root, 'config', 'course_missing.json')) )
  end
end
