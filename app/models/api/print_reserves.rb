module API
  class PrintReserves < Base
    BASE_PATH = "/1.0/resources/courses/print_reserves/"

    def self.all()
      path = 'all'

      get_json(path)
    end


    def self.find_by_bib_id(bib_id)

    end


    def self.find_by_rta_id(rta_id)

    end



  end
end
