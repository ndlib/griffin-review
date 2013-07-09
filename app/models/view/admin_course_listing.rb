
class AdminCourseListing
  attr_accessor :semester, :filter

  def initialize(current_user, params)
    @current_user = current_user
    @semester = determine_semester(params)
    @netid = params[:netid]
  end


  def search_semesters

  end


  def search
    @search_results ||= course_search.instructed_courses(@netid, @semester.code)
  end


  def has_results?
    (search.size > 0)
  end


  def has_searched?
    !@netid.nil?
  end


  private

    def course_search
      @course_search ||= CourseSearch.new
    end


    def determine_semester(params)
      if params.has_key?(:semester_id)
        Semester.find(params[:semester_id])
      else
        Semester.current.first
      end
    end


end
