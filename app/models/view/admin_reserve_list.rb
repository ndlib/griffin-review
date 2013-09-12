class AdminReserveList
  attr_accessor :semester, :request_tabs

  def initialize(current_user, params)
    @current_user = current_user
    @semester = determine_semester(params)
    @request_tabs = RequestTab.new(params[:tab])
  end


  def reserves
    reserve_search.admin_requests(@request_tabs.filter, 'all', 'all') # (@filter.types, @filter.libraries)
  end


  private

    def determine_semester(params)
      if params.has_key?(:semester_id)
        Semester.find(params[:semester_id])
      else
        false
      end
    end


    def reserve_search
      @reserve_search ||= ReserveSearch.new
    end

end
