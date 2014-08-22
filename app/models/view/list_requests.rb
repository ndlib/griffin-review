class ListRequests
  attr_accessor  :request_filter, :request_tabs


  def self.build_from_params(controller)
    filter = RequestFilter.new(controller)
    tab = RequestTab.new(controller.params[:tab])

    self.new(tab, filter)
  end


  def initialize(tab, filter)
    @request_tabs = tab
    @request_filter = filter
  end


  def reserves
    reserve_search.admin_requests(determine_semester)
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
