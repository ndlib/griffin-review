class CourseReserveList

  include ModelErrorTrapping
  include GetCourse

  attr_accessor :course, :current_user

  delegate :title, to: :course


  def self.build_from_params(controller)
    course = CourseSearch.new.get(controller.params[:course_id])
    current_user = controller.current_user

    self.new(course, current_user)
  end


  def initialize(course, current_user)
    @current_user = current_user
    @course = course

    validate_inputs!
  end


  def course_id
    @course.id
  end


  def has_deleted_reserves?
    @course.reserves.find { | r | r.removed? }.present?
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
    @instructs_course ||= (UserRoleInCoursePolicy.new(@course, @current_user).user_instructs_course? || UserIsAdminPolicy.new(@current_user).is_admin?)
  end


  def enrolled_in_course?
    @enrolled_course ||= UserRoleInCoursePolicy.new(@course, @current_user).user_enrolled_in_course?
  end


  def show_partial
    if instructs_course?
      { partial: 'instructed_course_show', locals: { user_course_show: self }}
    elsif enrolled_in_course?
      { partial: 'enrolled_course_show', locals: { user_course_show: self }}
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
        raise_404
      end
    end


end
