class DeleteCourseUserForm
  include ModelErrorTrapping
  include GetCourse

  include ActionView::Helpers::UrlHelper
  include ActionView::Helpers::OutputSafetyHelper

  delegate :url_helpers, to: 'Rails.application.routes'

  attr_accessor :course_user

  def initialize(course_user)
    @course_user = course_user
  end


  def self.build_from_params(params)
    @course = CourseSearch.new.get(params[:course_id])
    users = @course.enrollments.select { | user |  user.id.to_s == params[:id].to_s }
    if !users.first
      users = @course.instructors.select { | user |  user.id.to_s == params[:id].to_s }
    end

    if users.first
      self.new(users.first)
    else
      raise_404
    end
  end


  def delete_link
    if can_delete?
      link_to(raw("<i class=\"icon-remove\"></i>"),
                     url_helpers.course_user_path(@course_user.course.id, @course_user.user.id),
                      data: { confirm: 'Are you sure you wish to remove the exception for this user from the course?' },
                      :method => :delete,
                      :id => "delete_user_#{@course_user.user.id}")
    end
  end


  def destroy
    if !can_delete?
      raise_404
    end

    course_user_exception.destroy
  end


  private

    def can_delete?
      @course_user.can_be_deleted?
    end


    def course_user_exception
      if !ucx = UserCourseException.user_course_exception(@course_user.course.id, @course_user.user.username, @course_user.course.semester.code)
        raise_404
      end

      ucx
    end
end
