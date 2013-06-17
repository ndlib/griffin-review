
class AdminRequestListing
  attr_accessor :semester, :filter

  def initialize(current_user, params)
    @current_user = current_user
    @semester = determine_semester(params)
    @filter = AdminRequestFilter.new(params[:filter])
  end


  def reserves
    if @filter.new? || @filter.awaiting?
      in_complete_reserves
    elsif @filter.complete?
      completed_reserves
    elsif @filter.all?
      all_reserves
    else
      raise 'reserve called with out filter'
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
      reserve_search.new_and_inprocess_reserves_for_semester(@semester)
    end


    def completed_reserves
      reserve_search.available_reserves_for_semester(@semester)
    end


    def all_reserves
      reserve_search.all_reserves_for_semester(@semester)
    end


    def reserve_search
      @reserve_search ||= ReserveSearch.new
    end

end
