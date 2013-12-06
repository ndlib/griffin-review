

class SipxCourseButton
  include RailsHelpers

  def self.init_from_params(controller)

  end


  def initialize(course, current_user)
    @course = course
    @current_user = current_user
  end


  def goto_sipx_button
    link_to(helpers.raw("<i class=\"icon icon-arrow-up\"></i> Go To Sipx</a>"), course_sipx_admin_redirect_path(course.id), class: "btn", target: "_blank")
  end


  def redirect_url
    SipxRedirect.new(@course, @current_user).admin_redirect_url
  end


end
