class CourseMock < Course

  def semester
    @semeseter ||= Semester.current.first
  end


  def self.mock_data
    JSON.parse( IO.read(File.join(Rails.root, 'config', 'course_mock.json')) )
  end

end
