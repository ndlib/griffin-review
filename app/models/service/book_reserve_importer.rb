class BookReserveImporter
  attr_accessor :errors, :successes

  def import!
    print_reserves.each do | api_data |
      ibr = BookReserveImport.new(api_data)
      ibr.import!

      save_result(ibr)
    end
  end


  private


    def print_reserves
      API::PrintReserves.all
    end


    def save_result(ibr)
      if ibr.success?
        add_succsses(ibr)
      else
        add_error(ibr)
      end

    end


    def add_error(ibr)
      @errors ||= []
      @errors << { bib_id: ibr.bib_id, course_id: ibr.course_id, errors: ibr.errors }
    end


    def add_succsses(ibr)
      @successes ||= []
      @successes << { bib_id: ibr.bib_id, course_id: ibr.course_id }
    end

end




