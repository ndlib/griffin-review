class CopyCourseReservesForm
  include ModelErrorTrapping
  include GetCourse

  attr_accessor :from_course, :to_course

  def initialize(current_user, params)
    @from_course = get_course(params[:course_id])
    @to_course   = get_course(params[:to_course_id])

    @items_to_copy = params[:reserve_ids]

    validate_inputs!
  end


  def from_course_title
    @from_course.title
  end


  def to_course_title
    @to_course.title
  end


  def copied_items
    @copied_items ||= []
  end


  def self.current_semester_courses(current_user)
    ucl = UserCourseListing.new(current_user, Semester.current.first.code)
    ucl.instructed_courses
  end


  def self.next_semester_courses(current_user)
    next_semester = Semester.current.first.next
    if next_semester
      ucl = UserCourseListing.new(current_user, next_semester.code)
      ucl.instructed_courses
    else
      []
    end
  end


  def copy_items()
    return [] if !@items_to_copy

    reserve_search = ReserveSearch.new

    @copied_items = []
    @items_to_copy.each do | rid |
      begin
        reserve = reserve_search.get(rid, @from_course)
        if reserve
          @copied_items << CopyReserve.new(@to_course, reserve).copy
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

    def validate_inputs!
      if @from_course.nil? || @to_course.nil?
        render_404
      end

      if !to_course_can_have_new_reserves?
        render_404
      end
    end
end
