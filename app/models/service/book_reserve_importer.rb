class BookReserveImporter
  attr_accessor :errors, :successes


  def self.import!
    BookReserveImporter.new.import!
  end


  def import!
    print_reserves.each do | api_data |
      ibr = BookReserveImport.new(api_data)
      ibr.import!

      save_result(ibr)
    end

    log_result
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
      ibr.reserves.each do |reserve|
        @successes << { bib_id: ibr.bib_id, course_id: ibr.course_id, reserve_id: reserve.id }
      end
    end


    def log_result
      if !@errors.nil? && @errors.size > 0
        txt = "Aleph Importer Finished with errors "

        @errors.each do | e |
          txt += "\nBIB_ID: #{e[:bib_id]} COURSE: #{e[:course_id]} ERRORS: #{e[:errors].join(", ")}"
        end
      else
        txt = "Aleph Importer Finished without errors"
      end

      ErrorLog.log_message('aleph_import', txt)
    end

end




