class SakaiIntegratorController < ApplicationController

  skip_before_filter :verify_authenticity_token

  def sakai_redirect
    begin
      si = SakaiIntegrator.new(self)
      si.site_id = params[:context_id]
      external_site_id = si.get_site_property('externalSiteId')
      course_id = si.translate_external_site_id(external_site_id)
      if !course_id.blank?
        redirect_to '/sakai' + course_reserves_path(:course_id => course_id)
      else
        raise_404("Course id not found")
      end
    rescue Exception => e
      log_error(e)
      redirect_to '/sakai/courses'
    end
  end

end
