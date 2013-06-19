class UserCourseShow
  include ModelErrorTrapping
  include GetCourse

  attr_accessor :course, :current_user

  delegate :title, :instructor_name, to: :course

  def initialize(current_user, params)
    @current_user = current_user
    @course = get_course(params[:id])

    validate_inputs!
  end


  def course_id
    @course.id
  end


  def reserves
    if enrolled_in_course?
      @course.published_reserves
    elsif instructs_course?
      @course.reserves
    else
      raise "unable to determine reserves"
    end
  end


  def instructs_course?
    @instructs_course ||= UserRoleInCoursePolicy.new(@course, @current_user).user_instructs_course?
  end


  def enrolled_in_course?
    @enrolled_course ||= UserRoleInCoursePolicy.new(@course, @current_user).user_enrolled_in_course?
  end


  def show_partial
    if enrolled_in_course?
      { partial: 'enrolled_course_show', locals: { user_course_show: self }}
    elsif instructs_course?
      { partial: 'instructed_course_show', locals: { user_course_show: self }}
    else
      raise "unable to determin partial"
    end
  end


  def can_have_new_reserves?
    CreateNewReservesPolicy.new(@course).can_create_new_reserves?
  end


  def current_or_future_semester?
    @course.semester.current? || @course.semester.future?
  end


  private

    def validate_inputs!
      if @course.nil?
        render_404
      end
    end


end
