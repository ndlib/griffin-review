module API
  class PrintReserves < Base
    BASE_PATH = "/1.0/resources/courses/print_reserves/"

    def self.all()
      path = 'all'

      get_json(path)
    end

  end
end
