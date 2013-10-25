class CopyCourseReservesForm
  include ModelErrorTrapping

  attr_accessor :from_course, :to_course

  def initialize(current_user, params)
    @to_course = get_course(params[:course_id])

    if params.has_key?(:from_course_id)
      @from_course   = get_course(params[:from_course_id])
    end

    @items_to_copy = params[:reserve_ids]

    @user = current_user

    validate_inputs!
  end


  def from_course_title
    "#{@from_course.title} - #{@from_course.semester.full_name}"
  end


  def to_course_title
    "#{@to_course.title} - #{@to_course.semester.full_name}"
  end


  def copied_items
    @copied_items ||= []
  end


  def all_semesters
    Semester.chronological
  end


  def step1?
    @from_course.nil? && @to_course.present?
  end


  def step2?
    @from_course.present? && @to_course.present?
  end


  def copy_from_reserves
    @from_course.reserves
  end


  def semester_instructed_courses_with_reserves(semester)
    @semester_courses ||= {}
    @semester_courses[semester.code] ||= CourseSearch.new.instructed_courses(@user.username, semester.code).reject { | c | c.reserves.empty? }
  end


  def semester_has_courses?(semester)
    (semester_instructed_courses_with_reserves(semester).size > 0)
  end


  def copy_items()
    return [] if !@items_to_copy

    reserve_search = ReserveSearch.new

    @copied_items = []
    @items_to_copy.each do | rid |
      begin
        reserve = reserve_search.get(rid, @from_course)
        if reserve
          @copied_items << CopyReserve.new(@user, @to_course, reserve).copy
        end
      rescue ActiveRecord::RecordNotFound
        # skip missing items
      end
    end

    return @copied_items
  end


  def to_course_can_have_new_reserves?
    CreateNewReservesPolicy.new(@to_course).can_create_new_reserves?
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


    def validate_inputs!

      if @to_course && !to_course_can_have_new_reserves?
        raise_404
      end
    end

end
