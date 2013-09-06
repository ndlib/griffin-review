
class AdminReserveList
  attr_accessor :semester, :filter

  def initialize(current_user, params)
    @current_user = current_user
    @semester = determine_semester(params)
    @filter = AdminRequestFilter.new(params[:filter])
  end


  def reserves
    reserve_search.reserves_by_status_for_semester(@filter.reserve_status)
  end


  private

    def determine_semester(params)
      if params.has_key?(:semester_id)
        Semester.find(params[:semester_id])
      else
        Semester.current.first
      end
    end


    def reserve_search
      @reserve_search ||= ReserveSearch.new
    end

end
