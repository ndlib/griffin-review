class CopyOldCourseReservesForm
  include ModelErrorTrapping


  def initialize(current_user, params)
    @to_course_id = params[:course_id]
    @from_course_id = params[:from_course_id]
    @term = params[:term]

    if params[:auto_complete]
      @auto_complete = params[:auto_complete]
    else
      @auto_complete = false
    end

    @current_user = current_user
    validate_inputs!
  end


  def to_course
    @to_course ||= get_course(@to_course_id)
  end


  def to_course_title
    "#{to_course.full_title}"
  end


  def terms
    @terms ||= OpenCourse.connection.select('SELECT DISTINCT term from course').collect { | t | t['term'] }
  end


  def courses
    if !@term.nil?
      OpenCourse.where(term: @term)
    else
      []
    end
  end


  def has_courses_for_term?
    courses.size > 0
  end


  def from_course
    if @from_course_id
      begin
        @from_course ||= OpenCourse.find(@from_course_id)
      rescue ActiveRecord::RecordNotFound
        nil
      end
    else
      nil
    end
  end


  def copy!
    @copied_items = []

    from_course.reserves.each do | old_reserve |
      puts "from course: #{from_course.course_id}"
      @copied_items << CopyOldReserve.new(@current_user, to_course, old_reserve, @auto_complete).copy
    end

    @copied_items
  end


  private

    def get_course(id)
      c = course_search.get(id)

      if c.nil?
        raise_404
      end

      c
    end


    def course_search
      @course_search ||= CourseSearch.new
    end


    def to_course_can_have_new_reserves?
      CreateNewReservesPolicy.new(to_course).can_create_new_reserves?
    end


    def validate_inputs!
      if to_course.nil? || !to_course_can_have_new_reserves?
        raise_404
      end
    end
end
