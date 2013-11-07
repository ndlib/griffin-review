module API
  class CourseSearchApi < Base
    BASE_PATH = "/1.0/resources/courses/"


    def self.course_id(course_id)
      Rails.cache.fetch("course_id-#{course_id}-#{cache_key_date_code}")  do
        get_json("by_section_group/#{course_id}")
      end
    end


    def self.courses_by_crosslist_id(crosslist_id)
      Rails.cache.fetch("crosslist_id-#{crosslist_id}-#{cache_key_date_code}")  do
        get_json("by_crosslist/#{crosslist_id}")
      end
    end


    def self.course_by_section_id(term_code, section_id)
      path = File.join("by_section", term_code, section_id)
      get_json(path)
    end


    def self.course_by_triple(course_triple)
      Rails.cache.fetch("course_by_triple-#{course_triple}-#{cache_key_date_code}")  do
        get_json("by_course_triple/#{course_triple}")
      end
    end


    def self.search(term_code, q)
      get_json("search", { q: q, term: term_code })
    end


    def self.cache_key_date_code
      # -5 hours because the api reindexes at 4:30am and I want the cache to be expired after that is over.
      (current_time - 5.hours).to_s(:cache_key)
    end


    def self.current_time
      #this exists so I can stub this in test it was not allowing me to Time.stub(:now).and_return
      Time.now
    end
  end
end
