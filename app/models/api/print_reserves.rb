module API
  class PrintReserves < Base
    BASE_PATH = "/1.0/resources/courses/print_reserves/"

    def self.all()
      Rails.cache.fetch("print_reserves--all", expires_in: 1.hours)  do
        path = 'all'

        get_json(path)
      end
    end


    def self.find_by_bib_id_course_id(bib_id, course_id)
      all.select { | s | (s['bib_id'] == bib_id && s['crosslist_id'] == course_id) }
    end


    def self.find_by_rta_id_course_id(rta_id, course_id)
      all.select { | s | s['doc_number'] == rta_id && s['crosslist_id'] == course_id }
    end


    def self.rta(rta_id, key = false)
      path = "rta/#{rta_id}"

      get_json(path, { test: key })
    end

  end
end
