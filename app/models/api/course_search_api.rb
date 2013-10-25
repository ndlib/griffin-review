module API
  class CourseSearchApi < Base
    BASE_PATH = "/1.0/resources/courses/"


    def self.course_id(course_id)
      Rails.cache.fetch("course_id-#{course_id}", expires_in: 14.hours)  do
        get_json("by_section_group/#{course_id}")
      end
    end


    def self.courses_by_crosslist_id(crosslist_id)
      Rails.cache.fetch("crosslist_id-#{crosslist_id}", expires_in: 14.hours)  do
        get_json("by_crosslist/#{crosslist_id}")
      end
    end


    def self.course_by_section_id(term_code, section_id)
      path = File.join("by_section", term_code, section_id)
      get_json(path)
    end


    def self.course_by_triple(course_triple)
      Rails.cache.fetch("course_by_triple-#{course_triple}", expires_in: 14.hours)  do
        get_json("by_course_triple/#{course_triple}")
      end
    end


    def self.search(term_code, q)
      get_json("search", { q: q, term: term_code })
    end

  end
end
