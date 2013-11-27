class SipxRedirectController < ApplicationController


  def resource_redirect

  end


  def admin_redirect
    check_admin_permission!

    course = CourseSearch.new.get(params[:course_id])
    sipx_redirect = SipxRedirect.new(course, current_user)

    redirect_to sipx_redirect.admin_redirect_url
  end


end
