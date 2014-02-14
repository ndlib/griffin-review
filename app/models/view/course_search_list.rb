
class CourseSearchList
  attr_accessor :semester, :search

  def initialize(controller)
    params = controller.params

    @semester = determine_semester(params)
    @search = params[:q]
  end


  def search
    if @search
      @search_results ||= course_search.search(@semester.code, @search)
    else
      []
    end
  end


  def semesters
    Semester.chronological
  end


  def semester_option_array
    semesters.collect { | s | [s.full_name, s.id] }
  end


  def has_results?
    (search.size > 0)
  end


  def has_searched?
    !@search.nil?
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
