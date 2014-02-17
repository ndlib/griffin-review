class RequestList
  attr_accessor :request_tabs, :request_filter

  def initialize(controller)
    @request_tabs   = RequestTab.new(controller.params[:tab])
    @request_filter = RequestFilter.new(controller)
  end


  def reserves
    reserve_search.admin_requests(request_tabs.filter, request_filter.type_filters, request_filter.library_filters, determine_semester)
  end


  def semester_title
    if semester = determine_semester
      "for #{semester.full_name}"
    else
      "for Current and Upcoming Semesters"
    end
  end


  private

    def determine_semester
      if request_filter.semester_filter
        @semester ||= Semester.find(request_filter.semester_filter)
      else
        false
      end
    end


    def reserve_search
      @reserve_search ||= ReserveSearch.new
    end

end
