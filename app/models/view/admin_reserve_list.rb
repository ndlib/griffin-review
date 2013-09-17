class AdminReserveList
  attr_accessor :semester, :request_tabs, :request_filter

  def initialize(controller)
    @semester       = determine_semester(controller.params)
    @request_tabs   = RequestTab.new(controller.params[:tab])
    @request_filter = RequestFilter.new(controller)
  end


  def reserves
    reserve_search.admin_requests(request_tabs.filter, request_filter.type_filters, request_filter.library_filters, @semester)
  end


  private

    def determine_semester(params)
      if params.has_key?(:semester_id) && params[:semester_id]
        Semester.find(params[:semester_id])
      else
        false
      end
    end


    def reserve_search
      @reserve_search ||= ReserveSearch.new
    end

end
