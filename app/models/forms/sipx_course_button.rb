

class SipxCourseButton
  include RailsHelpers

  def initialize(course)
    @course = course
  end


  def goto_sipx_button
    helpers.link_to(helpers.raw("<i class=\"icon icon-arrow-up\"></i> Go To Sipx</a>"), '#', class: "btn", target: "_blank")
  end


  def redirect_url(current_user)

  end


  private


    def sipx_connection

    end




end
