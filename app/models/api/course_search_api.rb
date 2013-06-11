module API
  class CourseSearchApi < Base
    BASE_PATH = "/1.0/resources/courses/"


    def self.course_id(course_id)
      get_json("by_course_triple/#{course_id}")
    end


    def self.course_by_section_id(term_code, section_id)
      path = File.join("by_section", term_code, section_id)
      get_json(path)
    end


    def self.search(netid, semester)
      raise "not implemented"
      path = File.join("by_netid", netid, semester, "courses")

      result = get_json(path)
      result["people"].first
    end

  end
end
