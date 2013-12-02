class SipxRedirectController < ApplicationController


  def resource_redirect
    reserve = ReserveSearch.new().get(params[:id])

    check_view_permissions!(reserve.course)

    @ep = ElectronicReservePolicy.new(reserve)
    if !@ep.has_sipx_resource?
      raise_404
    end

    sipx_redirect = SipxRedirect.new(reserve.course, current_user)

    redirect_to sipx_redirect.course_redirect_url(@ep.sipx_url)
  end


  def admin_redirect
    check_admin_permission!

    course = CourseSearch.new.get(params[:course_id])
    sipx_redirect = SipxRedirect.new(course, current_user)

    redirect_to sipx_redirect.admin_redirect_url
  end


end
