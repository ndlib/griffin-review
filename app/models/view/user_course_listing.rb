class UserCourseListing
  include ModelErrorTrapping

  attr_accessor :semester

  def initialize(current_user)
    @user = current_user
  end


  def all_semesters
    Semester.cronologial
  end


  def current_semester
    Semester.current.first
  end


  def next_semester
    current_semester.next
  end


  def current_semester_title
    current_semester.full_name
  end


  def upcoming_semester_title
    next_semester.full_name
  end


  def show_both_enrolled_and_instructed_courses?
    show_enrolled_courses? && show_instructed_courses?
  end


  def show_enrolled_courses?
    !enrolled_courses.empty?
  end


  def show_instructed_courses?
    show_current_instructed_courses? || show_upcoming_instructed_courses?
  end


  def show_current_instructed_courses?
    !current_instructed_courses.empty?
  end


  def show_upcoming_instructed_courses?
    !upcoming_instructed_courses.empty?
  end


  def has_no_courses?
    !show_enrolled_courses? && !show_instructed_courses?
  end


  def enrolled_courses
    @enrolled_courses ||= course_search.enrolled_courses(@user.username, current_semester.code).reject { | c | c.published_reserves.empty? }
  end


  def current_instructed_courses
    @current_instructed_courses ||=  course_search.instructed_courses(@user.username, current_semester.code)
  end


  def upcoming_instructed_courses
    if !next_semester
      return []
    end

    @upcoming_instruced_courses ||= course_search.instructed_courses(@user.username, next_semester.code)
  end


  private

    def course_search
      @course_search ||= CourseSearch.new
    end

end
