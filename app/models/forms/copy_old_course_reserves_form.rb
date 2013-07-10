class CopyOldCourseReservesForm
  include ModelErrorTrapping



  def initialize(current_user, params)
    @to_course_id = params[:course_id]
    @from_course_id = params[:from_course_id]

    validate_inputs!
  end



  def to_course
    @to_course ||= get_course(@to_course_id)
  end


  def from_course
    begin
      @from_course ||= OpenCourse.find(@from_course_id)
    rescue ActiveRecord::RecordNotFound
      nil
    end
  end


  def copy!

    from_course.reserves.each do | old_reserve |


    end

  end


  private

    def get_course(id)
      c = course_search.get(id)

      if c.nil?
        render_404
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
        render_404
      end

      if from_course.nil?
        render_404
      end
    end
end
