
class AdminReserveList
  attr_accessor :semester, :filter

  def initialize(current_user, params)
    @current_user = current_user
    @semester = determine_semester(params)
    @filter = AdminRequestFilter.new(params[:filter])
  end


  def reserves
    if @filter.complete?
      completed_reserves
    elsif @filter.removed?
      removed_reserves
    else
      in_complete_reserves
    end
  end


  private

    def determine_semester(params)
      if params.has_key?(:semester_id)
        Semester.find(params[:semester_id])
      else
        Semester.current.first
      end
    end


    def in_complete_reserves
      reserve_search.new_and_inprocess_reserves_for_semester()
    end


    def completed_reserves
      reserve_search.available_reserves_for_semester()
    end


    def removed_reserves
      reserve_search.removed_reserves_for_semester()
    end


    def all_reserves
      reserve_search.all_reserves_for_semester()
    end


    def reserve_search
      @reserve_search ||= ReserveSearch.new
    end

end
